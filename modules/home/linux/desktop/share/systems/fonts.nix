{ lib, config, ... }:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    fonts.fontconfig = {
      defaultFonts = {
        serif = [ "${config.profiles.fonts.serif}" ];
        sansSerif = [
          "inter"
          "${config.profiles.fonts.sansSerif}"
        ];
        monospace = [ "${config.profiles.fonts.monospace}" ];
        emoji = [ "${config.profiles.fonts.emoji}" ];
      };
    };

    xdg.mimeApps.defaultApplications =
      let
        font-manager = [ "com.github.FontManager.FontViewer.desktop" ];
      in
      {
        "font/ttf" = font-manager;
        "font/ttc" = font-manager;
        "font/otf" = font-manager;
        "font/sfnt" = font-manager;
        "application/x-font-ttf" = font-manager;
        "application/x-font-otf" = font-manager;
        "application/vnd.ms-opentype" = font-manager;
      };

  };
}
