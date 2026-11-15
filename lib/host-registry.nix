{
  inputs,
  lib,
  hostsDir ? ../hosts,
}:

let
  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      validName = builtins.length parts == 2 && builtins.all (part: part != "") parts;
      configPath = hostsDir + "/${name}/nixpkgs.json";

      metadata =
        if !validName then
          throw "Invalid host directory '${name}', expected <username>@<hostname>"
        else
          let
            parsed = builtins.fromJSON (builtins.readFile configPath);
          in
          if builtins.isAttrs parsed then parsed else throw "${configPath} must contain a JSON object.";

      allowedFields = [
        "system"
        "os"
        "home-manager"
        "home-manager-nixpkgs"
        "nixosWsl"
      ];
      unknownFields = builtins.filter (field: !(builtins.elem field allowedFields)) (
        builtins.attrNames metadata
      );

      rawSystem = metadata.system or (throw "Missing 'system' in ${configPath}.");
      system =
        if
          builtins.isString rawSystem && builtins.match "[A-Za-z0-9_]+-(linux|darwin)" rawSystem != null
        then
          rawSystem
        else
          throw "'system' in ${configPath} must be a Linux or Darwin platform such as 'x86_64-linux'.";

      rawOs = metadata.os or (throw "Missing 'os' in ${configPath}; use null for standalone Home Manager hosts.");
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

      rawHomeManager = metadata."home-manager" or (throw "Missing 'home-manager' in ${configPath}.");
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

      checkedNixosWsl =
        if nixosWsl && class != "nixos" then
          throw "'nixosWsl' in ${configPath} is only valid for NixOS hosts."
        else
          nixosWsl;

      nixosWslInputValidated = !checkedNixosWsl || builtins.hasAttr "nixos-wsl" inputs
        || throw "Host '${name}' references missing flake input 'nixos-wsl'.";

      nixosWslModule = if checkedNixosWsl then inputs."nixos-wsl".nixosModules.default else null;

      hasHomeManagerNixpkgs = builtins.hasAttr "home-manager-nixpkgs" metadata;
      rawHomeManagerNixpkgs =
        if class != "home" then
          if hasHomeManagerNixpkgs then
            throw "'home-manager-nixpkgs' in ${configPath} is only valid for standalone Home Manager hosts."
          else
            null
        else
          metadata."home-manager-nixpkgs" or (throw "Missing 'home-manager-nixpkgs' in ${configPath} for standalone Home Manager hosts.");

      homeManagerNixpkgsInput =
        if class != "home" then
          null
        else if builtins.isString rawHomeManagerNixpkgs && rawHomeManagerNixpkgs != "" then
          checkInput rawHomeManagerNixpkgs
        else
          throw "'home-manager-nixpkgs' in ${configPath} must be a non-empty flake input name.";

      checkInput =
        inputName:
        if builtins.hasAttr inputName inputs then
          inputName
        else
          throw "Host '${name}' references missing flake input '${inputName}'.";

      validatedOsInput = if osInput == null then null else checkInput osInput;
      validatedHomeManagerInput = checkInput homeManagerInput;

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
          ;
        nixosWsl = checkedNixosWsl;
        inherit nixosWslModule homeManagerNixpkgsInput nixosWslInputValidated;
        osInput = validatedOsInput;
        homeManagerInput = validatedHomeManagerInput;
        path = hostsDir + "/${name}";
      };

  parsedHosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # Force only lightweight metadata and input-existence checks, not host configurations.
  hosts = builtins.deepSeq (map (host: {
    inherit (host)
      class
      system
      nixosWsl
      nixosWslInputValidated
      osInput
      homeManagerInput
      homeManagerNixpkgsInput
      ;
  }) (lib.attrValues parsedHosts)) parsedHosts;

  selectHosts = class: lib.filterAttrs (_: host: host.class == class) hosts;

  hostMetadata = lib.mapAttrs (_: host: {
    inherit (host)
      username
      hostName
      class
      system
      nixosWsl
      osInput
      homeManagerInput
      homeManagerNixpkgsInput
      ;
  }) hosts;
in
{
  inherit
    hostMetadata
    hosts
    ;
  nixosHosts = selectHosts "nixos";
  darwinHosts = selectHosts "darwin";
  homeHosts = selectHosts "home";
}
