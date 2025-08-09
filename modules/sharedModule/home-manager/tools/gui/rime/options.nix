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
        map (
          file: "echo -n ${pkgs.lib.escapeShellArg file.data} > $out/share/rime-data/${file.name}"
        ) cfg.extraFiles
      )}
    '';
  };

in
{
  options.modules'.packages.rime = with lib; {

    extraFiles = mkOption rec {
      default = [ ];
      description = "Extra files to be included in the Rime data package.";
      apply = userValue: default ++ userValue;
    };

    data-package = mkOption {
      default = makeRimeData;
      description = "The Rime data package.";
    };
  };

}
