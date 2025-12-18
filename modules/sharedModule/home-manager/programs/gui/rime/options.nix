{
  lib,
  pkgs,
  config,
  nvfetcherSources,
  ...
}:
let
  cfg = config.modules'.packages.rime;

  RimeLMDG = nvfetcherSources.rime-lmdg.src;
  oh-my-rime = nvfetcherSources.oh-my-rime.src;

  makeRimeData = pkgs.stdenv.mkDerivation {
    pname = "my-rime-data";
    version = "1.0";

    srcs = [
      RimeLMDG
      oh-my-rime
    ];

    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/share/rime-data

      cp ${RimeLMDG} $out/share/rime-data/wanxiang-lts-zh-hans.gram
      cp -r ${oh-my-rime}/* $out/share/rime-data/

      # 写入自定义文件（如果有）
      ${pkgs.lib.concatStringsSep "\n" (
        map (file: "ln -s ${file} $out/share/rime-data/${file.name}") cfg.extraFiles
      )}
    '';
  };

in
{
  options.modules'.packages.rime = with lib; rec {

    defaultCustomYaml = mkOption {
      type = types.attrs;
      default = { };
      description = "Default custom YAML configuration.";
    };
    rime_mintCustomYaml = mkOption {
      type = types.attrs;
      default = { };
      description = "Custom YAML configuration for rime-mint.";
    };
    fcitx5CustomYaml = mkOption {
      type = types.attrs;
      default = { };
      description = "Custom YAML configuration for Fcitx5.";
    };
    squirrelCustomYaml = mkOption {
      type = types.attrs;
      default = { };
      description = "Custom YAML configuration for Squirrel.";
    };
    extraFiles = mkOption {
      readOnly = true;
      default =
        let
          yamkFormats = pkgs.formats.yaml { };
        in
        [
          (yamkFormats.generate "rime_mint.custom.yaml" cfg.rime_mintCustomYaml)
          (yamkFormats.generate "squirrel.custom.yaml" cfg.squirrelCustomYaml)
          (yamkFormats.generate "default.custom.yaml" cfg.defaultCustomYaml)
          (yamkFormats.generate "fcitx5.custom.yaml" cfg.fcitx5CustomYaml)
        ];
      description = "Extra files to be included in the Rime data package.";
    };
    data-package = mkOption {
      default = makeRimeData;
      description = "The Rime data package.";
    };
    patch = {
      type = types.attrs;
      default = { };
    };
  };

}
