{
  flake.modules.homeManager.rime =
    { lib, pkgs, ... }:
    let
      yamkFormats = pkgs.formats.yaml { };
    in
    {
      options.profiles.rime = {
        defaultCustomYaml = lib.mkOption {
          inherit (yamkFormats) type;
          default = { };
          description = "Default custom YAML configuration.";
        };

        fcitx5CustomYaml = lib.mkOption {
          inherit (yamkFormats) type;
          default = { };
          description = "Custom YAML configuration for Fcitx5.";
        };

        squirrelCustomYaml = lib.mkOption {
          inherit (yamkFormats) type;
          default = { };
          description = "Custom YAML configuration for Squirrel.";
        };

        themes = {
          dark = lib.mkOption {
            type = lib.types.str;
            default = "macOS-dark";
            description = "The dark theme name to use.";
          };
          light = lib.mkOption {
            type = lib.types.str;
            default = "macOS-light";
            description = "The light theme name to use.";
          };
        };

        data-package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          description = "The generated Rime data package containing custom configurations.";
        };
      };

    };
}
