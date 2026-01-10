{
  lib,
  config,
  pkgs,
  ...

}:
let
  cfg = config.programs.noctalia-shell;
in
{

  config = lib.mkIf (cfg.enable) {

    programs.noctalia-shell.settings = {
      appLauncher = {
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
      };
      bar = {
        backgroundOpacity = lib.mkDefault 0.88;
        capsuleOpacity = 1;
        density = "comfortable";
        exclusive = true;
        floating = false;
        monitors = [ ];
        outerCorners = lib.mkDefault true;
        position = "top";
        showCapsule = false;
        showOutline = false;
        useSeparateOpacity = false;
        widgets = {
          center = [
            {
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "idle";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 225;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = true;
              useFixedWidth = true;
              visualizerType = "linear";
            }
            {
              id = "plugin:todo";
            }
            {
              id = "plugin:privacy-indicator";
            }
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
                "blueman-applet"
                "udiskie"
              ];
              colorizeIcons = false;
              drawerEnabled = false;
              id = "Tray";
            }
            {
              compactMode = false;
              diskPath = "/";
              id = "SystemMonitor";
              showCpuTemp = false;
              showCpuUsage = false;
              showDiskUsage = false;
              showMemoryAsPercent = true;
              showMemoryUsage = true;
              showNetworkStats = true;
              usePrimaryColor = true;
            }
            {
              id = "KeepAwake";
            }
            {
              id = "plugin:screen-recorder";
            }
            {
              id = "Network";
              displayMode = "alwaysShow";
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
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-fruit-salad";
        predefinedScheme = "Catppuccin";
        schedulingMode = "off";
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
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
          ];
        };
      };
      dock = {
        enabled = false;
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
      };
      general = {
        allowPanelsOnScreenWithoutBar = true;
        animationDisabled = false;
        animationSpeed = lib.mkDefault 0.68;
        avatarImage = "${config.home.homeDirectory}/.face";
        boxRadiusRatio = 1;
        compactLockScreen = false;
        dimmerOpacity = 0;
        enableShadows = false;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        lockOnSuspend = true;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 0;
        shadowDirection = "center";
        showHibernateOnLockScreen = false;
        showScreenCorners = lib.mkDefault true;
        showSessionButtonsOnLockScreen = false;
      };
      hooks = {
        screenLock = "";
        screenUnlock = "";
        darkModeChange =
          let
            hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
              mode=$1

              is_random="${lib.boolToString cfg.settings.wallpaper.randomEnabled}"

              if [ "$mode" = "true" ]; then
                switch-theme ${config.profiles.themes.gtkTheme.dark}
                [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/Dynamic-Wallpapers/Dark/Summer-Scene-Dark.png DP-1
              else
                switch-theme ${config.profiles.themes.gtkTheme.light}
                [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/Dynamic-Wallpapers/Light/Summer-Scene-Light.png DP-1
              fi
            '';
          in
          "${lib.getExe hook_theme} $1";
        enabled = true;
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
      nightLight = {
        autoSchedule = true;
        dayTemp = "5500";
        enabled = true;
        forced = false;
        nightTemp = "3300";
      };
      notifications = {
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
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
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
        enabledTypes = [
          0
          1
          2
          3
          4
        ];
        location = "bottom";
        monitors = [ ];
        overlayLayer = true;
      };
      templates = {
        alacritty = false;
        code = true;
        discord = false;
        enableUserTemplates = true;
        niri = false;
        hyprland = false;
        cava = true;
        foot = false;
        fuzzel = false;
        ghostty = true;
        gtk = true;
        kcolorscheme = true;
        kitty = true;
        pywalfox = true;
        telegram = true;
        qt = true;
        spicetify = false;
        vicinae = true;
        walker = false;
        wezterm = true;
        neovim = false;
        tmux = true;
        btop = true;
        yazi = true;
        zed = true;
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
        randomEnabled = false;
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
        wallhavenResolutionMode = "atleast";
        wallhavenSorting = "relevance";

      };
    };

  };

}
