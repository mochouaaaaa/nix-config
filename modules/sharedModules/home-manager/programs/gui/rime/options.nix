{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.profiles.rime;
  yamkFormats = pkgs.formats.yaml { };
in
{
  options.profiles.rime = {
    defaultCustomYaml = lib.mkOption {
      type = yamkFormats.type;
      default = { };
      description = "Default custom YAML configuration.";
    };

    fcitx5CustomYaml = lib.mkOption {
      type = yamkFormats.type;
      default = { };
      description = "Custom YAML configuration for Fcitx5.";
    };

    squirrelCustomYaml = lib.mkOption {
      type = yamkFormats.type;
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

  config = {
    profiles.rime.data-package =
      let
        genIfNotEmpty =
          name: value:
          lib.optional (value != { }) {
            inherit name;
            path = yamkFormats.generate name value;
          };

        extraFiles = lib.flatten (
          lib.mapAttrsToList genIfNotEmpty {
            "squirrel.custom.yaml" = cfg.squirrelCustomYaml;
            "default.custom.yaml" = cfg.defaultCustomYaml;
            "fcitx5.custom.yaml" = cfg.fcitx5CustomYaml;
          }
        );
      in
      pkgs.stdenv.mkDerivation {
        pname = "my-rime-data";
        version = "1.0";

        unpackPhase = "true";
        installPhase = ''
          mkdir -p $out/share/rime-data

          cp -r ${pkgs.rime-wanxiang}/share/rime-data/* $out/share/rime-data/

          ${lib.concatStringsSep "\n" (
            map (file: "ln -sf ${file.path} $out/share/rime-data/${file.name}") extraFiles
          )}
        '';
      };
  };
}
