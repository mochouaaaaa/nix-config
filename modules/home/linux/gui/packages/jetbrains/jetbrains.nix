{
  pkgs,
  lib,
  config,
  nvfetcherSources,
  ...
}:
let
  cfg = config.modules.packages.jetbrains;
  jetbrainsConfig = enable: {
    pycharm = enable && cfg.pycharm.enable;
    goland = enable && cfg.goland.enable;
    datagrip = enable && cfg.datagrip.enable;
    clion = enable && cfg.clion.enable;
  };

  initjetbrains = jetbrainsConfig cfg.enable;

  jetbra = pkgs.stdenv.mkDerivation {
    name = "jetbra";
    src = ./JetBrains;

    installPhase = ''
      mkdir -p $out/share
      cp -r * $out/share

      cat > $out/share/vmoptions << EOF
        --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
        --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

        -javaagent:$out/share/ja-netfilter.jar=jetbrains
        -Dawt.toolkit.name=WLToolkit
      EOF
    '';
  };

  vmoptions = builtins.readFile "${jetbra}/share/vmoptions";
in
{
  options.modules.packages.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs";
    pycharm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (pkgs.jetbrains.pycharm-professional.override { vmopts = vmoptions; }).overrideAttrs {
          src = nvfetcherSources.pycharm.src;
        };
      };
    };
    goland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (pkgs.jetbrains.goland.override { vmopts = vmoptions; }).overrideAttrs {
          src = nvfetcherSources.goland.src;
        };
      };
    };
    datagrip = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (pkgs.jetbrains.datagrip.override { vmopts = vmoptions; }).overrideAttrs {
          src = nvfetcherSources.datagrip.src;
        };
      };
    };
    clion = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (pkgs.jetbrains.clion.override { vmopts = vmoptions; }).overrideAttrs {
          src = nvfetcherSources.clion.src;
        };
      };
    };
  };

  config = {
    home.packages =
      [
      ]
      ++ (lib.optionals (initjetbrains.pycharm) [
        cfg.pycharm.package
      ])
      ++ (lib.optionals (initjetbrains.goland) [
        cfg.goland.package
      ])
      ++ (lib.optionals (initjetbrains.datagrip) [
        cfg.datagrip.package
      ])
      ++ (lib.optionals (initjetbrains.clion) [
        cfg.clion.package
      ]);
  };
}
