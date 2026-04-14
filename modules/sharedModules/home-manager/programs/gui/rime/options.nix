{
  lib,
  pkgs,
  config,
  ...
}:
let

  cfg = config.profiles.packages.rime;
  yamkFormats = pkgs.formats.yaml { };

  CustomRimeData = pkgs.stdenv.mkDerivation {
    pname = "my-rime-data";
    version = "1.0";

    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/share/rime-data

      cp -r ${pkgs.rime-wanxiang}/share/rime-data/* $out/share/rime-data/

      # 写入自定义文件（如果有）
      ${pkgs.lib.concatStringsSep "\n" (
        map (file: "ln -s ${file} $out/share/rime-data/${file.name}") cfg._extraFiles
      )}
    '';
  };

in
{
  options.profiles.packages.rime = with lib; {

    defaultCustomYaml = mkOption {
      type = yamkFormats.type;
      default = { };
      description = "Default custom YAML configuration.";
    };
    fcitx5CustomYaml = mkOption {
      type = yamkFormats.type;
      default = { };
      description = "Custom YAML configuration for Fcitx5.";
    };
    squirrelCustomYaml = mkOption {
      type = yamkFormats.type;
      default = { };
      description = "Custom YAML configuration for Squirrel.";
    };
    _extraFiles = mkOption {
      readOnly = true;
      default =
        let
          genIfNotEmpty = name: value: lib.optional (value != { }) (yamkFormats.generate name value);
        in
        lib.flatten (
          lib.mapAttrsToList genIfNotEmpty {
            "squirrel.custom.yaml" = cfg.squirrelCustomYaml;
            "default.custom.yaml" = cfg.defaultCustomYaml;
            "fcitx5.custom.yaml" = cfg.fcitx5CustomYaml;
          }
        );
      description = "Extra files to be included in the Rime data package.";
    };
    data-package = mkOption {
      default = CustomRimeData;
      description = "The Rime data package.";
    };
    patch = {
      type = yamkFormats.type;
      default = { };
    };
  };

}
