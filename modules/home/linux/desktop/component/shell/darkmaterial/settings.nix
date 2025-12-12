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
        # --- 主题与外观 (Theming & Appearance) ---
        currentThemeName = "dynamic";
        customThemeFile = "";
        matugenScheme = "scheme-dynamic-contrast";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";

        # 透明度 (Transparency)
        dankBarTransparency = 0.78;
        dankBarWidgetTransparency = 0.78;
        popupTransparency = 1; # 完全不透明
        dockTransparency = 1; # 完全不透明

        # 颜色与样式 (Colors & Style)
        widgetBackgroundColor = "sch";
        surfaceBase = "s";
        cornerRadius = 16; # 圆角半径

        # --- 时间与单位 (Time & Units) ---
        use24HourClock = true;
        showSeconds = false;
        useFahrenheit = false; # 使用摄氏度 (Celsius)

        # --- 动画与壁纸 (Animation & Wallpaper) ---
        nightModeEnabled = false;
        animationSpeed = 1;
        customAnimationDuration = 500;
        wallpaperFillMode = "Fill";
        blurredWallpaperLayer = false;
        blurWallpaperOnOverview = false;

        # --- DankBar / 面板小部件显示 (Panel Widget Visibility) ---
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

        # --- 控制中心 (Control Center) ---
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
        hideBrightnessSlider = false;

        # --- 工作区 (Workspaces) ---
        showWorkspaceIndex = true;
        showWorkspacePadding = false;
        workspaceScrolling = false;
        showWorkspaceApps = true;
        maxWorkspaceIcons = 3;
        workspacesPerMonitor = true;
        dwlShowAllTags = false;
        workspaceNameIcons = { };
        waveProgressEnabled = true;

        # --- 小部件布局与显示模式 (Widget Layout & Compact Modes) ---
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = true;
        runningAppsGroupByApp = false;
        clockDateFormat = "";
        lockDateFormat = "";
        mediaSize = 1;

        # DankBar 布局 (Widget Arrangement)
        dankBarLeftWidgets = [
          "workspaceSwitcher"
          "focusedWindow"
        ];
        dankBarCenterWidgets = [
          "music"
          "clock"
          "weather"
        ];
        dankBarRightWidgets = [
          "systemTray"
          "clipboard"
          "cpuUsage"
          "memUsage"
          "notificationButton"
          "controlCenterButton"
        ];
        dankBarWidgetOrder = [ ]; # 留空

        # --- 应用启动器/Spotlight (Launcher/Spotlight) ---
        appLauncherViewMode = "list";
        spotlightModalViewMode = "list";
        sortAppsAlphabetically = false;
        launcherLogoMode = "apps";
        launcherLogoCustomPath = "";
        launcherLogoColorOverride = "";
        launcherLogoColorInvertOnMode = false;
        launcherLogoBrightness = 0.5;
        launcherLogoContrast = 1;
        launcherLogoSizeOffset = 0;

        # --- 网络与地理位置 (Network & Geolocation) ---
        weatherLocation = "北京市, 100010";
        weatherCoordinates = "39.9057136,116.3912972";
        useAutoLocation = false;
        weatherEnabled = true;
        networkPreference = "auto";
        vpnLastConnected = "";

        # --- 字体与主题 (Fonts & Themes) ---
        iconTheme = "System Default";
        fontFamily = "Monaco Nerd Font";
        monoFontFamily = "Fira Code";
        fontWeight = 400;
        fontScale = 1;
        dankBarFontScale = 1.2;

        # --- 记事本 (Notepad) ---
        notepadUseMonospace = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadLastCustomTransparency = 0.7;

        # --- 声音 (Sounds) ---
        soundsEnabled = true;
        useSystemSoundTheme = false;
        soundNewNotification = true;
        soundVolumeChanged = true;
        soundPluggedIn = true;

        # --- 电源管理 (Power Management) ---
        acMonitorTimeout = 1800;
        acLockTimeout = 1200;
        acSuspendTimeout = 3600;
        acSuspendBehavior = 0;
        batteryMonitorTimeout = 0;
        batteryLockTimeout = 0;
        batterySuspendTimeout = 0;
        batterySuspendBehavior = 0;
        lockBeforeSuspend = true;
        loginctlLockIntegration = true;

        # --- 杂项与自定义命令 (Misc & Custom Commands) ---
        launchPrefix = "";
        brightnessDevicePins = { };
        gtkThemingEnabled = false;
        qtThemingEnabled = false;
        syncModeWithPortal = true;
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

        # --- Dock (Dock Configuration) ---
        showDock = false;
        dockAutoHide = false;
        dockGroupByApp = false;
        dockOpenOnOverview = false;
        dockPosition = 1;
        dockSpacing = 4;
        dockBottomGap = 0;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";

        # --- DankBar 细节配置 (DankBar Detailed Configuration) ---
        notificationOverlayEnabled = false;
        dankBarAutoHide = false;
        dankBarOpenOnOverview = false;
        dankBarVisible = true;
        dankBarSpacing = 0;
        dankBarBottomGap = -1;
        dankBarInnerPadding = 2;
        dankBarPosition = 0;
        dankBarSquareCorners = true;
        dankBarNoBackground = true;
        dankBarGothCornersEnabled = true;
        dankBarBorderEnabled = false;
        dankBarBorderColor = "surfaceText";
        dankBarBorderOpacity = 1;
        dankBarBorderThickness = 1;

        # --- 弹窗与模态 (Popups & Modals) ---
        popupGapsAuto = true;
        popupGapsManual = 4;
        modalDarkenBackground = false;

        # --- 锁屏与通知 (Lock Screen & Notifications) ---
        lockScreenShowPowerActions = true;
        enableFprint = false;
        maxFprintTries = 3;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationPopupPosition = 0;
        osdAlwaysShowValue = false;

        # --- 屏幕与显示 (Screens & Display) ---
        screenPreferences = { };
        showOnLastDisplay = { };

        # --- 版本控制 (Version Control) ---
        configVersion = 1;
      };

    };

    # xdg.configFile."DankMaterialShell/settings.json" =
    #   let
    #     settingsFormat = pkgs.formats.json { };
    #   in
    #   {
    #     source = settingsFormat.generate "settings.json" {
    #
    #     };
    #   };

  };

}
