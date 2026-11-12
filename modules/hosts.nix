{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  hostsDir = ../hosts;

  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  selectNixpkgs =
    class: system:
    if class != "home" && system == "x86_64-darwin" then
      "nixpkgs-darwin"
    else if class == "home" then
      null
    else
      "nixpkgs";

  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      valid = builtins.length parts == 2 && builtins.all (part: part != "") parts;

      metadataPath = hostsDir + "/${name}/host.json";
      metadata =
        if valid then
          builtins.fromJSON (builtins.readFile metadataPath)
        else
          throw "Invalid host directory '${name}', expected <username>@<hostname>";

      hostClass = metadata.class or (throw "Missing 'class' in ${metadataPath}.");
      system = metadata.system or (throw "Missing 'system' in ${metadataPath}.");

      class =
        if builtins.elem hostClass [ "nixos" "darwin" "home" ] then
          hostClass
        else
          throw "Unsupported class '${hostClass}' in ${metadataPath}; expected nixos, darwin or home.";

      nixpkgsInput = selectNixpkgs class system;

      # Preserve the existing package-set policy:
      # NixOS and standalone HM use stable; Darwin HM follows the system source.
      homeManagerNixpkgsInput =
        if class == "darwin" then nixpkgsInput else "nixpkgs-stable";

      checkInput =
        inputName:
        if builtins.hasAttr inputName inputs then
          inputName
        else
          throw "Host '${name}' references missing flake input '${inputName}'.";
    in
    {
      username = builtins.elemAt parts 0;
      hostName = builtins.elemAt parts 1;
      # Keep the old argument available for existing modules; it now means hostname.
      platform = builtins.elemAt parts 1;
      inherit name class system;

      nixpkgsInput = if nixpkgsInput == null then null else checkInput nixpkgsInput;
      homeManagerNixpkgsInput = checkInput homeManagerNixpkgsInput;

      path = hostsDir + "/${name}";
    };

  parsedHosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # Validate only host metadata and input names; never force host configurations here.
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
        hostName
        platform
        system
        nixpkgsInput
        homeManagerNixpkgsInput
        ;
      inherit (config) myvars;
    };

  mkHomePkgs =
    input: system:
    import inputs.${input} {
      inherit system;
      config.allowUnfree = true;
    };

  hostMetadata = lib.mapAttrs (_: host: {
    inherit
      (host)
      username
      hostName
      class
      system
      nixpkgsInput
      homeManagerNixpkgsInput
      ;
  }) hosts;

in
{
  flake = {
    # A lightweight registry consumed by host-evaluations. It contains no
    # evaluated NixOS/Darwin/Home Manager configuration or package derivations.
    lib.hostMetadata = hostMetadata;

    nixosConfigurations = lib.mapAttrs (
      _name: host:
      inputs.${host.nixpkgsInput}.lib.nixosSystem {
        specialArgs = hostArgs host;

        modules = [
          inputs.home-manager.nixosModules.home-manager
          self.modules.nixos.core
          self.modules.nixos."services.base"
          self.modules.nixos.agenix
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
