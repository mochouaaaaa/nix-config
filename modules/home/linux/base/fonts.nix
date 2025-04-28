{ pkgs, ... }:
{
  home.packages = with pkgs; [
    font-awesome
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Monaco Nerd Font" ];
      sansSerif = [
        "inter"
        "Monaco Nerd Font"
      ];
      monospace = [ "Maple Mono NF" ];
      emoji = [ "Noto Color Emoji" ];
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
}
