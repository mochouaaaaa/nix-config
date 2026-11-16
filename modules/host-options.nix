{
  lib,
  ...
}:

let
  inherit (lib) types;

  hostType = types.submodule {
    options = {
      name = lib.mkOption {
        type = types.str;
        readOnly = true;
        description = "Host directory name.";
      };

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

      path = lib.mkOption {
        type = types.path;
        readOnly = true;
        description = "Path to the Host configuration directory.";
      };

      system = lib.mkOption {
        type = types.str;
        description = "Target system platform, such as x86_64-linux.";
      };

      os = lib.mkOption {
        type = types.nullOr types.str;
        description = "Flake input providing the system constructor, or null for standalone Home Manager.";
      };

      "home-manager" = lib.mkOption {
        type = types.str;
        description = "Flake input providing the Home Manager module and library.";
      };

      "home-manager-nixpkgs" = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional Flake input providing nixpkgs for standalone Home Manager.";
      };

      nixosWsl = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Whether this NixOS Host uses NixOS-WSL.";
      };
    };
  };

  hostsDir = ../hosts;

  hostDirectories = lib.filterAttrs (_: type: type == "directory") (
    builtins.readDir hostsDir
  );

  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      validName = builtins.length parts == 2 && builtins.all (part: part != "") parts;
      configPath = hostsDir + "/${name}/nixpkgs.json";

      parsed =
        if !validName then
          throw "Invalid host directory '${name}', expected <username>@<hostname>."
        else
          builtins.fromJSON (builtins.readFile configPath);
    in
    if !builtins.isAttrs parsed then
      throw "${configPath} must contain a JSON object."
    else
      parsed
      // {
        inherit name;
        username = builtins.elemAt parts 0;
        hostName = builtins.elemAt parts 1;
        path = hostsDir + "/${name}";
      };

  hosts = lib.mapAttrs (name: _: parseHost name) hostDirectories;
in
{
  options.hosts = lib.mkOption {
    type = types.attrsOf hostType;
    readOnly = true;
    description = "Host metadata loaded from hosts/*/nixpkgs.json.";
  };

  config.hosts = hosts;
}
