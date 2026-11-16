{
  inputs,
  lib,
  hosts,
  hostsDir ? ../hosts,
}:

let
  checkInput =
    name: inputName:
    if builtins.isString inputName && inputName != "" && builtins.hasAttr inputName inputs then
      inputName
    else
      throw "Host '${name}' references missing or invalid flake input '${toString inputName}'.";

  parseHost =
    name: metadata:
    let
      system = metadata.system;
      validSystem =
        builtins.isString system
        && builtins.match "[A-Za-z0-9_]+-(linux|darwin)" system != null;

      checkedSystem =
        if validSystem then
          system
        else
          throw "Host '${name}' must specify a Linux or Darwin platform such as 'x86_64-linux'.";

      osInput = metadata."system-input";

      class =
        if osInput == null then
          "home"
        else if lib.hasSuffix "-linux" checkedSystem then
          "nixos"
        else if lib.hasSuffix "-darwin" checkedSystem then
          "darwin"
        else
          throw "Cannot infer host configuration type from system '${checkedSystem}'.";

      homeManagerInput = checkInput name metadata."home-manager-input";

      nixosWsl =
        if metadata.nixosWsl && class != "nixos" then
          throw "Host '${name}' sets 'nixosWsl', which is only valid for NixOS hosts."
        else
          metadata.nixosWsl;

      nixosWslInputValidated =
        !nixosWsl
        || builtins.hasAttr "nixos-wsl" inputs
        || throw "Host '${name}' references missing flake input 'nixos-wsl'.";

      nixosWslModule = if nixosWsl then inputs."nixos-wsl".nixosModules.default else null;

      rawHomeManagerNixpkgs = metadata."home-manager-nixpkgs";

      homeManagerNixpkgsInput =
        if class != "home" then
          if rawHomeManagerNixpkgs != null then
            throw "'home-manager-nixpkgs' is only valid for standalone Home Manager hosts ('${name}')."
          else
            null
        else
          checkInput name (
            if rawHomeManagerNixpkgs == null then
              throw "Standalone Home Manager host '${name}' must specify 'home-manager-nixpkgs'."
            else
              rawHomeManagerNixpkgs
          );

      validatedOsInput = if osInput == null then null else checkInput name osInput;
    in
    {
      inherit
        name
        class
        nixosWsl
        nixosWslModule
        nixosWslInputValidated
        homeManagerNixpkgsInput
        ;
      inherit (metadata)
        username
        hostName
        ;
      system = checkedSystem;
      osInput = validatedOsInput;
      inherit homeManagerInput;
      path = hostsDir + "/${name}";
    };

  parsedHosts = lib.mapAttrs parseHost hosts;

  # Force only lightweight metadata and input-existence checks, not host configurations.
  checkedHosts = builtins.deepSeq (map (host: {
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

  selectHosts = class: lib.filterAttrs (_: host: host.class == class) checkedHosts;

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
  }) checkedHosts;
in
{
  inherit
    hostMetadata
    ;
  hosts = checkedHosts;
  nixosHosts = selectHosts "nixos";
  darwinHosts = selectHosts "darwin";
  homeHosts = selectHosts "home";
}
