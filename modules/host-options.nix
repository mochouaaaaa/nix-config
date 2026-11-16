{
  lib,
  ...
}:

let
  inherit (lib) types;

  hostType = types.submodule {
    options = {
      username = lib.mkOption {
        type = types.str;
        readOnly = true;
        description = "Username parsed from the Host directory name.";
      };

      hostName = lib.mkOption {
        type = types.str;
        readOnly = true;
        description = "Hostname parsed from the Host directory name.";
      };

      system = lib.mkOption {
        type = types.str;
        description = "Target system platform, such as x86_64-linux.";
      };

      "system-input" = lib.mkOption {
        type = types.nullOr types.str;
        default = "nixpkgs";
        description = "Flake input providing the NixOS or nix-darwin system constructor.";
      };

      "home-manager-input" = lib.mkOption {
        type = types.str;
        description = "Flake input providing the Home Manager module and library.";
      };

      "home-manager-nixpkgs" = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional Flake input providing an independent Home Manager package set; null inherits the system package set.";
      };

      "nixos-wsl-input" = lib.mkOption {
        type = types.nullOr types.str;
        default = "nixos-wsl";
        description = "Flake input providing the NixOS-WSL module.";
      };

      nixosWsl = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether this NixOS Host uses NixOS-WSL.";
      };
    };
  };

  hostsDir = ../hosts;

  hostDirectories = lib.filterAttrs (_: type: type == "directory") (
    builtins.readDir hostsDir
  );

  loadHostMetadata =
    name:
    let
      parts = lib.splitString "@" name;
      validName = builtins.length parts == 2 && builtins.all (part: part != "") parts;
      configPath = hostsDir + "/${name}/nixpkgs.json";

      metadata =
        if !validName then
          throw "Invalid Host directory '${name}', expected <username>@<hostname>."
        else
          lib.importJSON configPath;
    in
    if !builtins.isAttrs metadata then
      throw "${configPath} must contain a JSON object."
    else
      metadata
      // {
        username = builtins.elemAt parts 0;
        hostName = builtins.elemAt parts 1;
      };

  hosts = lib.mapAttrs (name: _: loadHostMetadata name) hostDirectories;
in
{
  options.hosts = lib.mkOption {
    type = types.attrsOf hostType;
    readOnly = true;
    description = "Host metadata loaded from hosts/*/nixpkgs.json.";
  };

  config.hosts = hosts;
}
