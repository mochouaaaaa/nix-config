{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  hostsDir = ../hosts;

  # nix flake check normally forces every nixosConfigurations toplevel.
  # The repository's lightweight check opts out of host outputs explicitly.
  checkOnly = builtins.getEnv "NIX_CONFIG_CHECK" == "1";

  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  defaultOsNixpkgs = system: if system == "x86_64-darwin" then "nixpkgs-darwin" else "nixpkgs";

  defaultHomeManagerNixpkgs =
    system: osNixpkgsInput:
    if lib.hasSuffix "-darwin" system && osNixpkgsInput != null then
      osNixpkgsInput
    else
      "nixpkgs-stable";

  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      valid = builtins.length parts == 2 && builtins.all (part: part != "") parts;

      configPath = hostsDir + "/${name}/nixpkgs.json";
      metadata =
        if valid then
          builtins.fromJSON (builtins.readFile configPath)
        else
          throw "Invalid host directory '${name}', expected <username>@<hostname>";

      allowedFields = [
        "system"
        "os"
        "home-manager"
        "nixosWsl"
      ];
      unknownFields = builtins.filter (field: !(builtins.elem field allowedFields)) (
        builtins.attrNames metadata
      );

      rawSystem = metadata.system or (throw "Missing 'system' in ${configPath}.");
      system =
        if builtins.isString rawSystem && rawSystem != "" then
          rawSystem
        else
          throw "'system' in ${configPath} must be a non-empty string.";

      rawOsNixpkgs = metadata.os or (defaultOsNixpkgs system);
      osNixpkgsInput =
        if rawOsNixpkgs == null then
          null
        else if builtins.isString rawOsNixpkgs && rawOsNixpkgs != "" then
          rawOsNixpkgs
        else
          throw "'os' in ${configPath} must be a flake input name or null.";

      class =
        if osNixpkgsInput == null then
          "home"
        else if lib.hasSuffix "-linux" system then
          "nixos"
        else if lib.hasSuffix "-darwin" system then
          "darwin"
        else
          throw "Cannot infer host configuration type from system '${system}' in ${configPath}.";

      rawHomeManagerNixpkgs =
        metadata."home-manager" or (defaultHomeManagerNixpkgs system osNixpkgsInput);
      homeManagerNixpkgsInput =
        if builtins.isString rawHomeManagerNixpkgs && rawHomeManagerNixpkgs != "" then
          rawHomeManagerNixpkgs
        else
          throw "'home-manager' in ${configPath} must be a non-empty flake input name.";

      rawNixosWsl = metadata.nixosWsl or false;
      nixosWsl =
        if builtins.isBool rawNixosWsl then
          rawNixosWsl
        else
          throw "'nixosWsl' in ${configPath} must be a boolean.";

      checkInput =
        inputName:
        if builtins.hasAttr inputName inputs then
          inputName
        else
          throw "Host '${name}' references missing flake input '${inputName}'.";

      validatedOsNixpkgsInput = if osNixpkgsInput == null then null else checkInput osNixpkgsInput;
    in
    if unknownFields != [ ] then
      throw "Unknown fields in ${configPath}: ${lib.concatStringsSep ", " unknownFields}"
    else
      {
        username = builtins.elemAt parts 0;
        hostName = builtins.elemAt parts 1;
        inherit
          name
          class
          system
          nixosWsl
          ;

        osNixpkgsInput = validatedOsNixpkgsInput;
        homeManagerNixpkgsInput = checkInput homeManagerNixpkgsInput;

        path = hostsDir + "/${name}";
      };

  parsedHosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # Validate only host metadata and input names; never force host configurations here.
  hosts = builtins.deepSeq (map (host: {
    inherit (host)
      class
      system
      nixosWsl
      osNixpkgsInput
      homeManagerNixpkgsInput
      ;
  }) (lib.attrValues parsedHosts)) parsedHosts;

  selectHosts = class: lib.filterAttrs (_: host: host.class == class) hosts;

  nixosHosts = selectHosts "nixos";
  darwinHosts = selectHosts "darwin";
  homeHosts = selectHosts "home";

  hostArgs = host: {
    inherit inputs self;
    inherit (host)
      username
      hostName
      system
      osNixpkgsInput
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
    inherit (host)
      username
      hostName
      class
      system
      nixosWsl
      osNixpkgsInput
      homeManagerNixpkgsInput
      ;
  }) hosts;

in
{
  flake = {
    # A lightweight registry consumed by host-evaluations. It contains no
    # evaluated NixOS/Darwin/Home Manager configuration or package derivations.
    lib.hostMetadata = hostMetadata;

    nixosConfigurations = lib.optionalAttrs (!checkOnly) (
      lib.mapAttrs (
        _name: host:
        inputs.${host.osNixpkgsInput}.lib.nixosSystem {
          specialArgs = hostArgs host;

          modules = [
            inputs.home-manager.nixosModules.home-manager
            self.modules.nixos.core
            self.modules.nixos."services.base"
            self.modules.nixos.agenix
          ]
          ++ lib.optional host.nixosWsl inputs.nixos-wsl.nixosModules.default
          ++ [
            (inputs.import-tree host.path)
          ];
        }
      ) nixosHosts
    );

    darwinConfigurations = lib.optionalAttrs (!checkOnly) (
      lib.mapAttrs (
        _name: host:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = hostArgs host;

          modules = [
            ({ lib, ... }: {
              nixpkgs.source = lib.mkForce inputs.${host.osNixpkgsInput}.outPath;
              nixpkgs.flake.source = lib.mkForce inputs.${host.osNixpkgsInput}.outPath;
              nixpkgs.hostPlatform = host.system;
            })

            inputs.home-manager.darwinModules.home-manager
            self.modules.darwin.core
            self.modules.darwin.agenix
            self.modules.darwin.home-manager

            (inputs.import-tree host.path)
          ];
        }
      ) darwinHosts
    );

    homeConfigurations = lib.optionalAttrs (!checkOnly) (
      lib.mapAttrs (
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
      ) homeHosts
    );
  };
}
