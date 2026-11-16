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
      osInput = metadata."system-input";
      nixosWsl = metadata.nixosWsl;

      class =
        if nixosWsl then
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

      homeManagerInput = checkInput name metadata."home-manager-input";

      nixosWslInput =
        if nixosWsl then
          checkInput name metadata."nixos-wsl-input"
        else
          null;

      nixosWslModule =
        if nixosWsl then
          inputs.${nixosWslInput}.nixosModules.default
        else
          null;

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
        homeManagerNixpkgsInput
        ;
      inherit (metadata)
        username
        hostName
        ;
      inherit system;
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
