{
  pkgs,
  ...
}:
{
  config = {

    fonts = {
      fontDir.enable = true;
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

    home-manager.sharedModules = [
      {
        config = {
          xdg.dataFile = {
            "fonts".source = "/run/current-system/sw/share/X11/fonts";
          };
        };
      }
    ];

  };
}
