{
  pkgs,
  myvars,
  ...
}: let
  jetbrainsConfig = enable: {
    pycharm = enable && myvars.packages.jetbrains.pycharm;
    goland = enable && myvars.packages.jetbrains.goland;
    datagrip = enable && myvars.packages.jetbrains.datagrip;
    clion = enable && myvars.packages.jetbrains.clion;
  };
  isDarwin = pkgs.stdenv.isDarwin;

  initjetbrains = jetbrainsConfig (myvars.packages.jetbrains.enable && !isDarwin);

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
in {
  home.packages = with pkgs;
    []
    ++ (lib.optionals (initjetbrains.pycharm) [
      (pkgs.jetbrains.pycharm-professional.override {vmopts = vmoptions;})
    ])
    ++ (lib.optionals (initjetbrains.goland)
      [(pkgs.jetbrains.goland.override {vmopts = vmoptions;})])
    ++ (lib.optionals (initjetbrains.datagrip)
      [(pkgs.jetbrains.datagrip.override {vmopts = vmoptions;})])
    ++ (lib.optionals (initjetbrains.clion)
      [(pkgs.jetbrains.clion.override {vmopts = vmoptions;})]);
}
