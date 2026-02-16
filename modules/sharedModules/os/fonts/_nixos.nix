{
  pkgs,
  ...
}:
{
  config = {

    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = false;
      packages = [ pkgs.corefonts ];
      fontconfig = {
        useEmbeddedBitmaps = true;
        defaultFonts = {
          serif = [
            "Monaco Nerd Font"
            "Source Han Serif"
          ];
          sansSerif = [ "Source Han Sans" ];
          monospace = [ "Maple Mono CN" ];
        };
      };
    };
  };
}
