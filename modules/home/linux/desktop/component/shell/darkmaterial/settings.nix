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
          currentThemeName = "dynamic";
          customThemeFile = "";
          matugenScheme = "scheme-fruit-salad";
          runUserMatugenTemplates = true;
          dankBarTransparency = 0.78;
          dankBarWidgetTransparency = 0.95;
          popupTransparency = 0.95;
          dockTransparency = 1;
          use24HourClock = true;
          showSeconds = false;
          useFahrenheit = false;
          nightModeEnabled = false;
          weatherLocation = "Beijing; China";
          weatherCoordinates = "39.9042,116.4074";
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
          controlCenterShowNetworkIcon = true;
          controlCenterShowBluetoothIcon = true;
          controlCenterShowAudioIcon = true;
          controlCenterWidgets = [
            {
              id = "volumeSlider";
              enabled = true;
              width = 50;
            }
            {
              id = "brightnessSlider";
              enabled = true;
              width = 50;
            }
            {
              id = "wifi";
              enabled = true;
              width = 50;
            }
            {
              id = "bluetooth";
              enabled = true;
              width = 50;
            }
            {
              id = "audioOutput";
              enabled = true;
              width = 50;
            }
            {
              id = "audioInput";
              enabled = true;
              width = 50;
            }
            {
              id = "nightMode";
              enabled = true;
              width = 50;
            }
            {
              id = "darkMode";
              enabled = true;
              width = 50;
            }
          ];
          showWorkspaceIndex = true;
          workspaceScrolling = false;
          showWorkspacePadding = true;
          showWorkspaceApps = true;
          maxWorkspaceIcons = 3;
          workspacesPerMonitor = true;
          workspaceNameIcons = {
          };
          waveProgressEnabled = true;
          clockCompactMode = false;
          focusedWindowCompactMode = false;
          runningAppsCompactMode = true;
          runningAppsCurrentWorkspace = true;
          clockDateFormat = "yyyy年MM月dd日 ";
          lockDateFormat = "yyyy年MM月dd日 ";
          mediaSize = 2;
          dankBarLeftWidgets = [
            {
              id = "launcherButton";
              enabled = true;
            }
            {
              id = "workspaceSwitcher";
              enabled = true;
            }
            {
              id = "focusedWindow";
              enabled = true;
            }
          ];
          dankBarCenterWidgets = [
            "music"
            "clock"
            "weather"
          ];
          dankBarRightWidgets = [
            { id = "systemTray"; }
            { id = "network_speed_monitor"; }
            { id = "cpuUsage"; }
            { id = "memUsage"; }
            { id = "clipboard"; }
            { id = "notificationButton"; }
            { id = "controlCenterButton"; }
          ];
          appLauncherViewMode = "list";
          spotlightModalViewMode = "list";
          sortAppsAlphabetically = false;
          networkPreference = "auto";
          iconTheme = "System Default";
          launcherLogoMode = "os";
          launcherLogoCustomPath = "";
          launcherLogoColorOverride = "";
          launcherLogoColorInvertOnMode = false;
          launcherLogoBrightness = 0.5;
          launcherLogoContrast = 1;
          launcherLogoSizeOffset = 0;
          fontFamily = "Monaco Nerd Font";
          monoFontFamily = "Fira Code";
          fontWeight = 400;
          fontScale = 1;
          dankBarFontScale = 1;
          notepadUseMonospace = true;
          notepadFontFamily = "";
          notepadFontSize = 14;
          notepadShowLineNumbers = false;
          notepadTransparencyOverride = -1;
          notepadLastCustomTransparency = 0.95;
          soundsEnabled = true;
          useSystemSoundTheme = false;
          soundNewNotification = true;
          soundVolumeChanged = true;
          soundPluggedIn = true;
          gtkThemingEnabled = true;
          qtThemingEnabled = true;
          syncModeWithPortal = true;
          showDock = false;
          dockAutoHide = false;
          dockGroupByApp = false;
          dockOpenOnOverview = false;
          dockPosition = 1;
          dockSpacing = 4;
          dockBottomGap = 0;
          dockIconSize = 40;
          cornerRadius = 20;
          notificationOverlayEnabled = false;
          dankBarAutoHide = false;
          dankBarOpenOnOverview = false;
          dankBarVisible = true;
          dankBarSpacing = 3;
          dankBarBottomGap = 0;
          dankBarInnerPadding = 4;
          dankBarSquareCorners = false;
          dankBarNoBackground = false;
          dankBarGothCornersEnabled = false;
          dankBarBorderEnabled = false;
          dankBarBorderColor = "surfaceText";
          dankBarBorderOpacity = 1;
          dankBarBorderThickness = 1;
          popupGapsAuto = true;
          popupGapsManual = 4;
          dankBarPosition = 0;
          lockScreenShowPowerActions = true;
          enableFprint = false;
          maxFprintTries = 3;
          hideBrightnessSlider = false;
          widgetBackgroundColor = "sch";
          surfaceBase = "sc";
          notificationTimeoutLow = 5000;
          notificationTimeoutNormal = 5000;
          notificationTimeoutCritical = 0;
          notificationPopupPosition = 0;
          osdAlwaysShowValue = false;
          powerActionConfirm = true;
          customPowerActionLock = "";
          customPowerActionLogout = "";
          customPowerActionSuspend = "";
          customPowerActionHibernate = "";
          customPowerActionReboot = "";
          customPowerActionPowerOff = "";
          updaterUseCustomCommand = false;
          updaterCustomCommand = "";
          updaterTerminalAdditionalParams = "";
          screenPreferences = {
            dankBar = [
              "all"
            ];
            dock = [ ];
            notifications = [
              "all"
            ];
            systemTray = [
              "all"
            ];
          };
          animationSpeed = 2;
          acMonitorTimeout = 600;
          acLockTimeout = 600;
          acSuspendTimeout = 1800;
          acHibernateTimeout = 900;
          batteryMonitorTimeout = 0;
          batteryLockTimeout = 0;
          batterySuspendTimeout = 0;
          batteryHibernateTimeout = 0;
          lockBeforeSuspend = true;
          loginctlLockIntegration = true;
          launchPrefix = "";
          configVersion = 1;
        };
      };

  };

}
