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

  resolveHost =
    name: metadata:
    let
      inherit (metadata) system;
      osInput = metadata."system-input";
      inherit (metadata) nixosWsl;

      class =
        if system == "" then
          throw "Host '${name}' must specify a non-empty system."
        else if nixosWsl then
          if osInput == null then
            throw "NixOS-WSL Host '${name}' must specify 'system-input'."
          else if !lib.hasSuffix "-linux" system then
            throw "NixOS-WSL Host '${name}' must target a Linux system."
          else
            "nixos"
        else if osInput == null then
          "home"
        else if lib.hasSuffix "-darwin" system then
          "darwin"
        else
          "nixos";

      desktop = metadata.desktop or null;

      validatedDesktop =
        if desktop != null && class != "nixos" then
          throw "Host '${name}' can select a desktop session only on NixOS."
        else
          desktop;

      homeManagerInput = checkInput name metadata."home-manager-input";

      nixosWslInput = if nixosWsl then checkInput name metadata."nixos-wsl-input" else null;

      nixosWslModule = if nixosWsl then inputs.${nixosWslInput}.nixosModules.default else null;

      rawHomeManagerNixpkgs = metadata."home-manager-nixpkgs";

      homeManagerNixpkgsInput =
        if rawHomeManagerNixpkgs == null then
          if class == "home" then
            throw "Standalone Home Manager host '${name}' must specify 'home-manager-nixpkgs'."
          else
            null
        else
          checkInput name rawHomeManagerNixpkgs;

      validatedOsInput = if osInput == null then null else checkInput name osInput;
    in
    {
      inherit
        name
        class
        nixosWsl
        nixosWslInput
        nixosWslModule
        homeManagerNixpkgsInput
        ;
      inherit (metadata)
        username
        hostName
        ;
      inherit system;
      desktop = validatedDesktop;
      osInput = validatedOsInput;
      inherit homeManagerInput;
      path = hostsDir + "/${name}";
    };

  parsedHosts = lib.mapAttrs resolveHost hosts;

  # Force only lightweight metadata and input-existence checks, not host configurations.
  checkedHosts = builtins.deepSeq (map (host: {
    inherit (host)
      class
      system
      desktop
      nixosWsl
      nixosWslInput
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
      desktop
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
