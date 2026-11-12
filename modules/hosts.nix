{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  hostsDir = ../hosts;

  # Keep host platform identifiers and their package-set systems in one place.
  # Add a distinct platform key when introducing another architecture.
  platformSystems = {
    nixos = "x86_64-linux";
    nixos-wsl = "x86_64-linux";
    darwin = "x86_64-darwin";
    wsl = "x86_64-linux";
  };

  # Automatically discover host directories.
  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      valid = builtins.length parts == 2 && builtins.all (part: part != "") parts;
      platform = if valid then builtins.elemAt parts 1 else null;
      pkgsSystem =
        if valid then
          platformSystems.${platform} or (throw "Unsupported platform '${platform}' in host '${name}'. Add it to platformSystems in modules/hosts.nix.")
        else
          throw "Invalid host directory '${name}', expected <username>@<platform>";
    in
    {
      username = builtins.elemAt parts 0;
      inherit platform pkgsSystem name;
      path = hostsDir + "/${name}";
    };

  parsedHosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # Force validation for every discovered directory, including platforms that
  # would otherwise be silently excluded from all configuration outputs.
  hosts = builtins.deepSeq (map (host: host.pkgsSystem) (lib.attrValues parsedHosts)) parsedHosts;

  selectHosts = platforms: lib.filterAttrs (_: host: builtins.elem host.platform platforms) hosts;

  nixosHosts = selectHosts [
    "nixos"
    "nixos-wsl"
  ];

  darwinHosts = selectHosts [ "darwin" ];

  homeHosts = selectHosts [ "wsl" ];

  hostArgs = host: {
    inherit inputs self;
    inherit (host) username platform pkgsSystem;
    hostName = host.name;
    inherit (config) myvars;
  };

  mkHomePkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

in
{
  flake = {
    nixosConfigurations = lib.mapAttrs (
      _name: host:
      inputs.nixpkgs.lib.nixosSystem {
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
        pkgs = mkHomePkgs host.pkgsSystem;

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
