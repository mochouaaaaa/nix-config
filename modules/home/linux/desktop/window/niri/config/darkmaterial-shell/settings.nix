{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.dankMaterialShell;
in
{

  config = lib.mkIf cfg.enable {

    xdg.configFile."DankMaterialShell/settings.json" =
      let
        settingsFormat = pkgs.formats.json { };
      in
      {
        source = settingsFormat.generate "settings.json" {
          themeIndex = 10;
          themeIsDynamic = true;
          topBarTransparency = 0.75;
          topBarWidgetTransparency = 0.85;
          popupTransparency = 0.92;
          dockTransparency = 1;
          use24HourClock = true;
          useFahrenheit = false;
          nightModeEnabled = false;
          weatherLocation = "Beijing; China";
          weatherCoordinates = "39.9042;116.4074";
          useAutoLocation = true;
          weatherEnabled = true;
          showLauncherButton = true;
          showWorkspaceSwitcher = true;
          showFocusedWindow = true;
          showWeather = true;
          showMusic = true;
          showClipboard = true;
          showCpuUsage = true;
          showMemUsage = true;
          showCpuTemp = true;
          showGpuTemp = true;
          selectedGpuIndex = 0;
          enabledGpuPciIds = [ ];
          showSystemTray = true;
          showClock = true;
          showNotificationButton = true;
          showBattery = true;
          showControlCenterButton = true;
          showWorkspaceIndex = true;
          showWorkspacePadding = true;
          workspaceNameIcons = {
            code = {
              type = "text";
              value = "󰨞";
            };
            browser = {
              type = "text";
              value = " ";
            };
            docs = {
              type = "text";
              value = " ";
            };
            obs = {
              type = "text";
              value = " ";
            };
            tencent = {
              type = "text";
              value = " ";
            };
            steam = {
              type = "text";
              value = " ";
            };
          };
          clockCompactMode = false;
          focusedWindowCompactMode = false;
          runningAppsCompactMode = true;
          clockDateFormat = "yyyy年MM月dd日 ";
          lockDateFormat = "yyyy年MM月dd日 ";
          mediaSize = 2;
          topBarLeftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          topBarCenterWidgets = [
            "music"
            "clock"
            "weather"
          ];
          topBarRightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "controlCenterButton"
          ];
          appLauncherViewMode = "list";
          spotlightModalViewMode = "list";
          networkPreference = "auto";
          iconTheme = "System Default";
          useOSLogo = true;
          osLogoColorOverride = "";
          osLogoBrightness = 0.5;
          osLogoContrast = 1;
          wallpaperDynamicTheming = true;
          fontFamily = "Inter Variable";
          monoFontFamily = "Fira Code";
          fontWeight = 400;
          gtkThemingEnabled = true;
          qtThemingEnabled = true;
          showDock = false;
          dockAutoHide = true;
          cornerRadius = 12;
          notificationOverlayEnabled = false;
          topBarAutoHide = false;
          notificationTimeoutLow = 5000;
          notificationTimeoutNormal = 5000;
          notificationTimeoutCritical = 0;
        };
      };

  };

}
