{
  lib,
  config,
  pkgs,
  ...

}:
let
  cfg = config.modules'.desktop.shell.noctalia;
in
{

  config = lib.mkIf (cfg.enable) {

    modules'.desktop.shell.noctalia.settings = rec {
      appLauncher = {
        backgroundOpacity = ui.panelBackgroundOpacity;
        customLaunchPrefixEnabled = true;
        enableClipboardHistory = true;
        pinnedExecs = [ ];
        position = "center";
        sortByMostUsed = true;
        terminalCommand = "kitty -e";
        useApp2Unit = false;
      };
      audio = {
        cavaFrameRate = 60;
        externalMixer = "pwvucontrol || pavucontrol";
        mprisBlacklist = [ ];
        preferredPlayer = "";
        visualizerQuality = "high";
        visualizerType = "linear";
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        density = "comfortable";
        exclusive = true;
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [ ];
        outerCorners = true;
        position = "top";
        showCapsule = false;
        showOutline = false;
        transparent = false;
        widgets = {
          center = [
          ];
          left = [
            {
              characterCount = 2;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = false;
              hideUnoccupied = true;
              id = "Workspace";
              labelMode = "index";
              showApplications = true;
              showLabelsOnlyWhenOccupied = true;
            }
          ];
          right = [
            {
              blacklist = [
                "nm-applet"
                "udiskie"
              ];
              colorizeIcons = false;
              drawerEnabled = false;
              id = "Tray";
            }
            {
              diskPath = "/";
              id = "SystemMonitor";
              showCpuTemp = false;
              showCpuUsage = false;
              showDiskUsage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = false;
              showNetworkStats = true;
              usePrimaryColor = true;
            }
            { id = "ScreenRecorder"; }
            {
              id = "WiFi";
              displayMode = "onhover";
            }
            {
              id = "Bluetooth";
              displayMode = "onhover";
            }
            {
              customIconPath = "";
              icon = "ease-in-out-control-points-filled";
              id = "ControlCenter";
              useDistroLogo = false;
            }
            {
              customFont = "";
              formatHorizontal = "yyyy-MM-dd ddd HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useCustomFont = false;
              usePrimaryColor = true;
            }
          ];
        };
      };
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = true;
      };
      colorSchemes = {
        darkMode = false;
        generateTemplatesForPredefined = true;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-fruit-salad";
        predefinedScheme = "Catppuccin";
        schedulingMode = "location";
        useWallpaperColors = true;
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
      };
      dock = {
        enabled = false;
        backgroundOpacity = ui.panelBackgroundOpacity;
        displayMode = "always_visible";
        floatingRatio = 1;
        monitors = [ ];
        onlySameOutput = true;
        pinnedApps = [ ];
      };
      general = {
        allowPanelsOnScreenWithoutBar = true;
        animationDisabled = false;
        animationSpeed = 0.68;
        avatarImage = "${config.home.homeDirectory}/.face";
        boxRadiusRatio = 1;
        compactLockScreen = false;
        dimmerOpacity = 0;
        dimDesktop = false;
        enableShadows = false;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        language = "";
        lockOnSuspend = true;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 0;
        shadowDirection = "center";
        shadowOffsetX = 0;
        shadowOffsetY = 0;
        showHibernateOnLockScreen = false;
        showScreenCorners = lib.mkDefault true;
        showSessionButtonsOnLockScreen = true;
      };
      hooks = {
        screenLock = "";
        screenUnlock = "";
        darkModeChange =
          let
            hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
              mode=$1

              if [ "$mode" = "true" ]; then
                switch-theme Dark
              else
                switch-theme Light
              fi
              (sleep 2 && pkill -SIGUSR1 kitty) &
            '';

          in
          "${lib.getExe hook_theme} $1";
        enabled = true;
        wallpaperChange =
          let
            hook_wallpaper = pkgs.writeShellScriptBin "hook_wallpaper" ''
              (sleep 2 && pkill -SIGUSR1 kitty) &
              # notify-send "$2:壁纸" "壁纸已更新"
            '';
          in
          "${lib.getExe hook_wallpaper} $1 $2";
      };
      location = {
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        name = "Beijing; China";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = true;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };
      network = {
        wifiEnabled = true;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "5500";
        enabled = true;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "3300";
      };
      notifications = {
        backgroundOpacity = ui.panelBackgroundOpacity;
        criticalUrgencyDuration = 15;
        enabled = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [ ];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = true;
      };
      osd = {
        enabled = true;
        autoHideMs = 3000;
        backgroundOpacity = ui.panelBackgroundOpacity;
        enabledTypes = [
          0
          1
          2
          3
        ];
        location = "bottom";
        monitors = [ ];
        overlayLayer = true;
      };
      screenRecorder = {
        audioCodec = "opus";
        audioSource = "both";
        colorRange = "full";
        directory = "${config.home.homeDirectory}/Videos/Recordings";
        frameRate = 60;
        quality = "very_high";
        showCursor = true;
        videoCodec = "h264";
        videoSource = "portal";
      };
      templates = {
        alacritty = false;
        code = false;
        discord = false;
        enableUserTemplates = true;
        niri = false;
        cava = true;
        foot = false;
        fuzzel = false;
        ghostty = true;
        gtk = true;
        kcolorscheme = true;
        kitty = true;
        pywalfox = false;
        qt = true;
        spicetify = false;
        vicinae = true;
        walker = false;
        wezterm = true;
        neovim = false;
        tmux = true;
        btop = true;
        yazi = true;
        zed = false;
      };
      ui = {
        panelBackgroundOpacity = 0.78;
        fontDefault = "Monaco Nerd Font";
        fontDefaultScale = 1;
        fontFixed = "Monaco Nerd Font Mono";
        fontFixedScale = 1;
        panelsAttachedToBar = true;
        settingsPanelMode = "centered";
        tooltipsEnabled = true;
      };
      wallpaper = {
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        fillColor = "#1e1e2e";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        monitorDirectories = [ ];
        overviewEnabled = false;
        panelPosition = "center";
        randomEnabled = true;
        randomIntervalSec = 300;
        recursiveSearch = true;
        setWallpaperOnAllMonitors = true;
        transitionDuration = 3000;
        transitionEdgeSmoothness = 0.15;
        transitionType = "random";
        useWallhaven = false;
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenQuery = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";

      };
    };

    programs.cava.settings = {
      theme = "noctalia";
    };

  };

}
