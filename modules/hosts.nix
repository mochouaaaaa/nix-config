{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  hostsDir = ../hosts;

  # Platform metadata describes only the configuration class and target system.
  # Package-set selection is kept separate so hosts can mix nixpkgs revisions.
  platforms = {
    nixos = {
      class = "nixos";
      system = "x86_64-linux";
    };

    nixos-wsl = {
      class = "nixos";
      system = "x86_64-linux";
    };

    darwin = {
      class = "darwin";
      system = "x86_64-darwin";
    };

    darwin-aarch64 = {
      class = "darwin";
      system = "aarch64-darwin";
    };

    wsl = {
      class = "home";
      system = "x86_64-linux";
    };
  };

  # Select package sources independently for the OS and Home Manager.
  packageSets = {
    nixos = {
      nixpkgs = "nixpkgs";
      homeManager = "nixpkgs-stable";
    };

    nixos-wsl = {
      nixpkgs = "nixpkgs";
      homeManager = "nixpkgs-stable";
    };

    darwin = {
      nixpkgs = "nixpkgs-darwin";
      homeManager = "system";
    };

    darwin-aarch64 = {
      nixpkgs = "nixpkgs";
      homeManager = "system";
    };

    wsl = {
      homeManager = "nixpkgs-stable";
    };
  };

  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      valid = builtins.length parts == 2 && builtins.all (part: part != "") parts;
      platform = if valid then builtins.elemAt parts 1 else null;

      platformInfo =
        if valid then
          platforms.${platform} or (throw "Unsupported platform '${platform}' in host '${name}'. Add it to platforms in modules/hosts.nix.")
        else
          throw "Invalid host directory '${name}', expected <username>@<platform>";

      packageSetInfo =
        packageSets.${platform}
          or (throw "Missing packageSets entry for platform '${platform}' in modules/hosts.nix.");

      nixpkgsInput = packageSetInfo.nixpkgs or null;

      homeManagerInput = packageSetInfo.homeManager or "system";

      homeManagerNixpkgsInput =
        if homeManagerInput == "system" then
          if nixpkgsInput == null then
            throw "Platform '${platform}' must define homeManager explicitly because it has no system nixpkgs input."
          else
            nixpkgsInput
        else
          homeManagerInput;

      checkInput =
        inputName:
        if builtins.hasAttr inputName inputs then
          inputName
        else
          throw "Platform '${platform}' references missing flake input '${inputName}'.";
    in
    {
      username = builtins.elemAt parts 0;
      inherit platform name;
      inherit (platformInfo) class system;

      nixpkgsInput = if nixpkgsInput == null then null else checkInput nixpkgsInput;
      homeManagerNixpkgsInput = checkInput homeManagerNixpkgsInput;

      path = hostsDir + "/${name}";
    };

  parsedHosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # Force validation for every discovered host and its package-set inputs.
  hosts = builtins.deepSeq (
    map
      (host: {
        inherit (host) class system nixpkgsInput homeManagerNixpkgsInput;
      })
      (lib.attrValues parsedHosts)
  ) parsedHosts;

  selectHosts = class: lib.filterAttrs (_: host: host.class == class) hosts;

  nixosHosts = selectHosts "nixos";
  darwinHosts = selectHosts "darwin";
  homeHosts = selectHosts "home";

  hostArgs =
    host:
    {
      inherit inputs self;
      inherit (host)
        username
        platform
        system
        nixpkgsInput
        homeManagerNixpkgsInput
        ;
      hostName = host.name;
      inherit (config) myvars;
    };

  mkHomePkgs =
    input: system:
    import inputs.${input} {
      inherit system;
      config.allowUnfree = true;
    };

in
{
  flake = {
    nixosConfigurations = lib.mapAttrs (
      _name: host:
      inputs.${host.nixpkgsInput}.lib.nixosSystem {
        specialArgs = hostArgs host;

        modules = [
          inputs.home-manager.nixosModules.home-manager
          self.modules.nixos.core
          self.modules.nixos."services.base"
          self.modules.nixos.agenix
        ]
        ++ lib.optional (host.platform == "nixos-wsl") inputs.nixos-wsl.nixosModules.default
        ++ [
          (inputs.import-tree host.path)
        ];
      }
    ) nixosHosts;

    darwinConfigurations = lib.mapAttrs (
      _name: host:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = hostArgs host;

        modules = [
          ({ lib, ... }: {
            nixpkgs.source = lib.mkForce inputs.${host.nixpkgsInput}.outPath;
            nixpkgs.flake.source = lib.mkForce inputs.${host.nixpkgsInput}.outPath;
            nixpkgs.hostPlatform = host.system;
          })

          inputs.home-manager.darwinModules.home-manager
          self.modules.darwin.core
          self.modules.darwin.agenix
          self.modules.darwin.home-manager

          (inputs.import-tree host.path)
        ];
      }
    ) darwinHosts;

    homeConfigurations = lib.mapAttrs (
      _name: host:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = mkHomePkgs host.homeManagerNixpkgsInput host.system;

        extraSpecialArgs = hostArgs host;

        modules = [
          self.modules.homeManager.agenix
          self.modules.homeManager.nix-settings

          (inputs.import-tree host.path)

          { programs.home-manager.enable = true; }
        ];
      }
    ) homeHosts;
  };
}
