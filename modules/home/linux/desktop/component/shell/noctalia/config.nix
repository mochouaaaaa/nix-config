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

    programs.noctalia-shell.settings = {
      appLauncher = {
        backgroundOpacity = 1;
        enableClipboardHistory = true;
        pinnedExecs = [ ];
        position = "center";
        sortByMostUsed = true;
        terminalCommand = "kitty -e";
        useApp2Unit = false;
      };
      audio = {
        cavaFrameRate = 60;
        mprisBlacklist = [ ];
        preferredPlayer = "";
        visualizerType = "linear";
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        backgroundOpacity = 0.6;
        density = "comfortable";
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [ ];
        position = "top";
        showCapsule = true;
        widgets = {
          center = [
          ];
          left = [
            {
              hideUnoccupied = true;
              id = "Workspace";
              labelMode = "index";
            }
          ];
          right = [
            {
              blacklist = [
                "nm-applet"
              ];
              id = "Tray";
            }
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
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
        position = "close_to_bar_button";
        quickSettingsStyle = "compact";
        widgets = {
          quickSettings = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Notifications";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "WallpaperSelector";
            }
          ];
        };
      };
      dock = {
        backgroundOpacity = 1;
        displayMode = "always_visible";
        floatingRatio = 1;
        monitors = [ ];
        onlySameOutput = true;
        pinnedApps = [ ];
      };
      general = {
        animationDisabled = false;
        animationSpeed = 0.97;
        avatarImage = "${config.home.homeDirectory}/.face";
        compactLockScreen = false;
        dimDesktop = false;
        forceBlackScreenCorners = false;
        lockOnSuspend = true;
        radiusRatio = 0.94;
        scaleRatio = 1;
        screenRadiusRatio = 0.5;
        showScreenCorners = true;
      };
      hooks = {
        darkModeChange =
          let
            hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
              mode=$1

              if [ "$mode" = "true" ]; then
                switch-theme Dark
              else
                switch-theme Light
              fi
            '';

          in
          "${lib.getExe hook_theme} $1";
        enabled = true;
        wallpaperChange = "";
      };
      location = {
        name = "Beijing; China";
        showCalendarEvents = true;
        showWeekNumberInCalendar = true;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
      };
      network = {
        wifiEnabled = true;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "5800";
        enabled = true;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "3300";
      };
      notifications = {
        criticalUrgencyDuration = 15;
        doNotDisturb = false;
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
        location = "top_right";
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
      settingsVersion = 16;
      templates = {
        discord = false;
        discord_armcord = false;
        discord_dorion = false;
        discord_equibop = false;
        discord_lightcord = false;
        discord_vesktop = false;
        discord_webcord = false;
        enableUserTemplates = true;
        foot = false;
        fuzzel = false;
        ghostty = false;
        gtk = false;
        kcolorscheme = false;
        kitty = false;
        pywalfox = false;
        qt = false;
        vicinae = true;
      };
      ui = {
        fontDefault = "Monaco Nerd Font";
        fontDefaultScale = 1;
        fontFixed = "Monaco Nerd Font Mono";
        fontFixedScale = 1;
        panelsOverlayLayer = true;
        tooltipsEnabled = true;
      };
      wallpaper = {
        defaultWallpaper = "";
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        fillColor = "#000000";
        fillMode = "crop";
        monitors = [
          {
            directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
            name = "DP-1";
            wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/zhizi.png";
          }
        ];
        randomEnabled = false;
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
      };
    };
  };

}
