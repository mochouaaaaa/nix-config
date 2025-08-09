{ config, lib, ... }:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      shortcuts = {
        "services/kitty.desktop" = {
          "_launch" = "Meta+Ctrl+T";
        };
        "services/org.kde.dolphin.desktop" = {
          "_launch" = "Meta+Ctrl+E";
        };
        "services/org.kde.konsole.desktop" = {
          "_launch" = [ ];
        };
        "services/org.kde.kscreen.desktop" = {
          "ShowOSD" = "Display";
        };
        "services/org.kde.plasma-systemmonitor.desktop" = {
          "_launch" = [ ];
        };
        "services/org.kde.plasma.emojier.desktop" = {
          "_launch" = [ ];
        };
        # "services/org.kde.krunner.desktop" = {
        #   "_launch" = ["Search" "Meta+Space"];
        # };
        "services/org.kde.spectacle.desktop" = {
          "ActiveWindowScreenShot" = "none";
          "FullScreenScreenShot" = "none";
          "RecordRegion" = "none";
          # "RectangularRegionScreenShot" = "Meta+Ctrl+A";
          # "WindowUnderCursorScreenShot" = "Meta+Ctrl+S";
          "_launch" = "none";
        };
      };
    };
  };
}
