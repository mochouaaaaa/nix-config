{
  pkgs,
  lib,
  config,
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
    src = ./JetBrains; # 将本地路径作为源

    installPhase = ''
      mkdir -p $out
      cp -r * $out # 将所有文件复制到输出目录
    '';
  };

  vmoptions = ''
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

    -javaagent:${jetbra}/ja-netfilter.jar=jetbrains
    -Dawt.toolkit.name=WLToolkit
  '';
in
{
  options.modules.packages.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs";
    pycharm.enable = lib.mkEnableOption "PyCharm IDE";
    goland.enable = lib.mkEnableOption "GoLand IDE";
    datagrip.enable = lib.mkEnableOption "DataGrip IDE";
    clion.enable = lib.mkEnableOption "CLion IDE";
  };
  config = {
    home.packages =
      with pkgs;
      [ ]
      ++ (lib.optionals (initjetbrains.pycharm) [
        (pkgs.jetbrains.pycharm-professional.override { vmopts = vmoptions; })
      ])
      ++ (lib.optionals (initjetbrains.goland) [
        (pkgs.jetbrains.goland.override { vmopts = vmoptions; })
      ])
      ++ (lib.optionals (initjetbrains.datagrip) [
        (pkgs.jetbrains.datagrip.override { vmopts = vmoptions; })
      ])
      ++ (lib.optionals (initjetbrains.clion) [
        (pkgs.jetbrains.clion.override { vmopts = vmoptions; })
      ]);
  };
}
