{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  hostsDir = ../hosts;

  # Keep the lightweight metadata check independent from full system evaluation.
  checkOnly = builtins.getEnv "NIX_CONFIG_CHECK" == "1";

  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  defaultOs = system:
    if lib.hasSuffix "-darwin" system then "nix-darwin" else "nixpkgs";

  defaultHomeManager = _: "home-manager";

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

      rawOs = metadata.os or (defaultOs system);
      osInput =
        if rawOs == null then
          null
        else if builtins.isString rawOs && rawOs != "" then
          rawOs
        else
          throw "'os' in ${configPath} must be a flake input name or null.";

      class =
        if osInput == null then
          "home"
        else if lib.hasSuffix "-linux" system then
          "nixos"
        else if lib.hasSuffix "-darwin" system then
          "darwin"
        else
          throw "Cannot infer host configuration type from system '${system}' in ${configPath}.";

      rawHomeManager = metadata."home-manager" or (defaultHomeManager system);
      homeManagerInput =
        if builtins.isString rawHomeManager && rawHomeManager != "" then
          rawHomeManager
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

      validatedOsInput = if osInput == null then null else checkInput osInput;
      validatedHomeManagerInput = checkInput homeManagerInput;

      systemConstructor =
        if class == "nixos" then "nixosSystem"
        else if class == "darwin" then "darwinSystem"
        else null;

      checkedOsInput =
        if validatedOsInput == null then null
        else if builtins.hasAttr "lib" inputs.${validatedOsInput}
          && builtins.hasAttr systemConstructor inputs.${validatedOsInput}.lib then
          validatedOsInput
        else
          throw "Flake input '${validatedOsInput}' for host '${name}' must provide lib.${systemConstructor}.";

      homeManagerModuleSet =
        if class == "nixos" then "nixosModules"
        else if class == "darwin" then "darwinModules"
        else null;

      checkedHomeManagerInput =
        if homeManagerModuleSet == null then
          if builtins.hasAttr "lib" inputs.${validatedHomeManagerInput}
            && builtins.hasAttr "homeManagerConfiguration" inputs.${validatedHomeManagerInput}.lib then
            validatedHomeManagerInput
          else
            throw "Home Manager input '${validatedHomeManagerInput}' must provide lib.homeManagerConfiguration."
        else if builtins.hasAttr homeManagerModuleSet inputs.${validatedHomeManagerInput}
          && builtins.hasAttr "home-manager" inputs.${validatedHomeManagerInput}.${homeManagerModuleSet} then
          validatedHomeManagerInput
        else
          throw "Home Manager input '${validatedHomeManagerInput}' must provide ${homeManagerModuleSet}.home-manager.";
    in
    if unknownFields != [ ] then
      throw "Unknown fields in ${configPath}: ${lib.concatStringsSep ", " unknownFields}"
    else
      {
        username = builtins.elemAt parts 0;
        hostName = builtins.elemAt parts 1;
        inherit name class system nixosWsl;
        osInput = checkedOsInput;
        homeManagerInput = checkedHomeManagerInput;
        path = hostsDir + "/${name}";
      };

  parsedHosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # Validate host metadata and input interfaces without evaluating configurations.
  hosts = builtins.deepSeq (map (host: {
    inherit (host) class system nixosWsl osInput homeManagerInput;
  }) (lib.attrValues parsedHosts)) parsedHosts;

  selectHosts = class: lib.filterAttrs (_: host: host.class == class) hosts;

  nixosHosts = selectHosts "nixos";
  darwinHosts = selectHosts "darwin";
  homeHosts = selectHosts "home";

  hostArgs = host: {
    inherit inputs self;
    inherit (host) username hostName system osInput class;
    inherit (config) myvars;
  };

  hostMetadata = lib.mapAttrs (_: host: {
    inherit (host) username hostName class system nixosWsl osInput homeManagerInput;
  }) hosts;

in
{
  flake = {
    lib.hostMetadata = hostMetadata;

    nixosConfigurations = lib.optionalAttrs (!checkOnly) (
      lib.mapAttrs (
        _name: host:
        inputs.${host.osInput}.lib.nixosSystem {
          specialArgs = hostArgs host;

          modules = [
            inputs.${host.homeManagerInput}.nixosModules.home-manager
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
        inputs.${host.osInput}.lib.darwinSystem {
          specialArgs = hostArgs host;

          modules = [
            ({ ... }: {
              nixpkgs.hostPlatform = host.system;
            })

            inputs.${host.homeManagerInput}.darwinModules.home-manager
            self.modules.darwin.core
            self.modules.darwin.env
            self.modules.darwin.homebrew
            self.modules.darwin.agenix
            self.modules.darwin.services
            self.modules.darwin.home-manager

            (inputs.import-tree host.path)
          ];
        }
      ) darwinHosts
    );

    homeConfigurations = lib.optionalAttrs (!checkOnly) (
      lib.mapAttrs (
        _name: host:
        inputs.${host.homeManagerInput}.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit (host) system;
            config.allowUnfree = true;
          };

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
