{ lib, config, ... }:
let
  cfg = config.profiles.desktop.shell.dank-material-shell;
in
{

  config = lib.mkIf cfg.enable {
    programs.dank-material-shell = {
      settings = lib.mkDefaultRecursive {
        barConfigs = [
          {
            autoHide = false;
            autoHideDelay = 250;
            borderColor = "surfaceText";
            borderEnabled = false;
            borderOpacity = 1;
            borderThickness = 1;
            bottomGap = 0;
            centerWidgets = [
              "music"
              {
                id = "clock";
                enabled = true;
                clockCompactMode = false;
              }
              "weather"
            ];
            enabled = true;
            fontScale = 1;
            gothCornerRadiusOverride = true;
            gothCornerRadiusValue = 10;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = 4;
            leftWidgets = [
              "workspaceSwitcher"
              "focusedWindow"
            ];
            maximizeDetection = true;
            name = "Main Bar";
            noBackground = false;
            openOnOverview = false;
            popupGapsAuto = true;
            popupGapsManual = 4;
            position = 0;
            rightWidgets = [
              {
                id = "systemTray";
                enabled = true;
              }
              {
                id = "privacyIndicator";
                enabled = true;
              }
              {
                id = "clipboard";
                enabled = false;
              }
              {
                id = "cpuUsage";
                enabled = true;
              }
              {
                id = "memUsage";
                enabled = true;
              }
              {
                id = "notificationButton";
                enabled = true;
              }
              {
                id = "battery";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
              }
            ];
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            spacing = 0;
            squareCorners = true;
            transparency = 0.44;
            visible = true;
            widgetOutlineColor = "primary";
            widgetOutlineEnabled = false;
            widgetOutlineOpacity = 1;
            widgetOutlineThickness = 1;
            widgetTransparency = 0.44;
          }
        ];
      };
    };
  };

}
