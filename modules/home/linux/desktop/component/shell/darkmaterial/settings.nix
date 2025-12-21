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

    programs.dankMaterialShell = {
      default.settings = {
        currentThemeName = "dynamic";
        customThemeFile = "";
        matugenScheme = "scheme-fruit-salad";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";
        popupTransparency = 0.78;
        dockTransparency = 1;
        widgetBackgroundColor = "sch";
        widgetColorMode = "default";
        cornerRadius = 15;
        use24HourClock = true;
        showSeconds = false;
        useFahrenheit = false;
        nightModeEnabled = false;
        animationSpeed = 1;
        customAnimationDuration = 500;
        wallpaperFillMode = "Fill";
        blurredWallpaperLayer = false;
        blurWallpaperOnOverview = false;
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
        showCapsLockIndicator = true;
        controlCenterShowNetworkIcon = true;
        controlCenterShowBluetoothIcon = true;
        controlCenterShowAudioIcon = true;
        controlCenterShowVpnIcon = true;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowMicIcon = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;
        showPrivacyButton = true;
        privacyShowMicIcon = false;
        privacyShowCameraIcon = false;
        privacyShowScreenShareIcon = false;
        controlCenterWidgets = [
          {
            enabled = true;
            id = "volumeSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "brightnessSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "wifi";
            width = 50;
          }
          {
            enabled = true;
            id = "bluetooth";
            width = 50;
          }
          {
            enabled = true;
            id = "audioOutput";
            width = 50;
          }
          {
            enabled = true;
            id = "audioInput";
            width = 50;
          }
          {
            enabled = true;
            id = "nightMode";
            width = 50;
          }
          {
            enabled = true;
            id = "darkMode";
            width = 50;
          }
        ];
        showWorkspaceIndex = true;
        showWorkspacePadding = false;
        workspaceScrolling = false;
        showWorkspaceApps = true;
        maxWorkspaceIcons = 3;
        workspacesPerMonitor = true;
        showOccupiedWorkspacesOnly = false;
        dwlShowAllTags = false;
        workspaceNameIcons = { };
        waveProgressEnabled = true;
        scrollTitleEnabled = true;
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = true;
        runningAppsGroupByApp = false;
        centeringMode = "index";
        clockDateFormat = "";
        lockDateFormat = "";
        mediaSize = 1;
        appLauncherViewMode = "list";
        spotlightModalViewMode = "list";
        sortAppsAlphabetically = false;
        appLauncherGridColumns = 4;
        spotlightCloseNiriOverview = true;
        niriOverviewOverlayEnabled = true;
        weatherLocation = "北京市; 100010";
        weatherCoordinates = "39.9057136;116.3912972";
        useAutoLocation = false;
        weatherEnabled = true;
        networkPreference = "auto";
        vpnLastConnected = "";
        iconTheme = "System Default";
        launcherLogoMode = "apps";
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
        notepadUseMonospace = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadLastCustomTransparency = 0.7;
        soundsEnabled = true;
        useSystemSoundTheme = false;
        soundNewNotification = true;
        soundVolumeChanged = true;
        soundPluggedIn = true;
        acMonitorTimeout = 1800;
        acLockTimeout = 1200;
        acSuspendTimeout = 3600;
        acSuspendBehavior = 2;
        acProfileName = "";
        batteryMonitorTimeout = 0;
        batteryLockTimeout = 0;
        batterySuspendTimeout = 0;
        batterySuspendBehavior = 0;
        batteryProfileName = "";
        lockBeforeSuspend = true;
        loginctlLockIntegration = true;
        fadeToLockEnabled = false;
        fadeToLockGracePeriod = 5;
        launchPrefix = "";
        brightnessDevicePins = { };
        wifiNetworkPins = { };
        bluetoothDevicePins = { };
        audioInputDevicePins = { };
        audioOutputDevicePins = { };
        gtkThemingEnabled = false;
        qtThemingEnabled = false;
        syncModeWithPortal = true;
        terminalsAlwaysDark = false;
        showDock = false;
        dockAutoHide = false;
        dockGroupByApp = false;
        dockOpenOnOverview = false;
        dockPosition = 1;
        dockSpacing = 4;
        dockBottomGap = 0;
        dockMargin = 0;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";
        dockBorderEnabled = false;
        dockBorderColor = "surfaceText";
        dockBorderOpacity = 1;
        dockBorderThickness = 1;
        notificationOverlayEnabled = false;
        modalDarkenBackground = false;
        lockScreenShowPowerActions = true;
        enableFprint = false;
        maxFprintTries = 3;
        lockScreenActiveMonitor = "all";
        lockScreenInactiveColor = "#000000";
        hideBrightnessSlider = false;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationPopupPosition = 0;
        osdAlwaysShowValue = true;
        osdPosition = 5;
        osdVolumeEnabled = true;
        osdMediaVolumeEnabled = true;
        osdBrightnessEnabled = true;
        osdIdleInhibitorEnabled = true;
        osdMicMuteEnabled = true;
        osdCapsLockEnabled = true;
        osdPowerProfileEnabled = false;
        osdAudioOutputEnabled = true;
        powerActionConfirm = true;
        powerActionHoldDuration = 0.5;
        powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "restart"
        ];
        powerMenuDefaultAction = "logout";
        powerMenuGridLayout = false;
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionSuspend = "";
        customPowerActionHibernate = "";
        customPowerActionReboot = "";
        customPowerActionPowerOff = "";
        updaterUseCustomCommand = false;
        updaterCustomCommand = "";
        updaterTerminalAdditionalParams = "";
        displayNameMode = "system";
        screenPreferences = {
          wallpaper = [
            "all"
          ];
        };
        showOnLastDisplay = { };
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            leftWidgets = [
              "workspaceSwitcher"
              "focusedWindow"
            ];
            centerWidgets = [
              "music"
              "clock"
              "weather"
            ];
            rightWidgets = [
              "systemTray"
              "clipboard"
              "cpuUsage"
              "memUsage"
              "notificationButton"
              "battery"
              "controlCenterButton"
            ];
            spacing = 0;
            innerPadding = 4;
            bottomGap = 0;
            transparency = 0.44;
            widgetTransparency = 0.44;
            squareCorners = true;
            noBackground = false;
            gothCornersEnabled = true;
            gothCornerRadiusOverride = true;
            gothCornerRadiusValue = 10;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            widgetOutlineEnabled = false;
            widgetOutlineColor = "primary";
            widgetOutlineOpacity = 1;
            widgetOutlineThickness = 1;
            fontScale = 1;
            autoHide = false;
            autoHideDelay = 250;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeDetection = true;
          }
        ];
      };
      plugins =
        let
          dms-plugins = pkgs.fetchFromGitHub {
            owner = "AvengeMedia";
            repo = "dms-plugins";
            rev = "cf0efeb8311bf59f9f4caec06689100ee5f1aa35";
            sha256 = "sha256-vEoax/uZ3VPe4zw6761dHiPMbYacYlg1hPyORiljWKc=";
          };
        in
        {
          dankHooks = {
            enable = true;
            src = "${dms-plugins}/DankHooks";
          };
          wallpaperBing = {
            enable = true;
            src = pkgs.fetchFromGitHub {
              owner = "max72bra";
              repo = "DankPluginBingWallpaper";
              rev = "bb06dbff5d2ababd1b675ad4bcc3cad36d7be42c";
              sha256 = "sha256-eewMJ0FaovLbaBenJlKkeaBgkXwYuG++W5h+6su62V0=";
            };
          };
        };

    };
  };

}
