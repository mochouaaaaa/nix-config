{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.noctalia-shell;
in
{

  config = lib.mkIf (cfg.enable) {

    programs.noctalia-shell.settings = {
      desktopWidgets = {
        enabled = false;
        gridSnap = true;
        monitorWidgets = [
          {
            name = "DP-1";
            widgets = [
              {
                clockStyle = "minimal";
                customFont = "${config.profiles.fonts.default} Nerd Font";
                format = "HH:mm\\nd MMMM yyyy";
                id = "Clock";
                roundedCorners = true;
                scale = 1.1714733944377378;
                showBackground = true;
                useCustomFont = true;
                usePrimaryColor = true;
                x = 1880;
                y = 120;
              }
              {
                id = "Weather";
                scale = 1.095091130678316;
                showBackground = true;
                x = 2160;
                y = 120;
              }
              {
                hideMode = "idle";
                id = "MediaPlayer";
                roundedCorners = true;
                scale = 1.5262421248111757;
                showAlbumArt = true;
                showBackground = true;
                showButtons = true;
                showVisualizer = true;
                visualizerType = "wave";
                x = 1880;
                y = 280;
              }
            ];
          }
        ];
      };

    };
  };
}
