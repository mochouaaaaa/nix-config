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
        backgroundOpacity = 1;
        density = "comfortable";
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [ ];
        position = "top";
        showCapsule = false;
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
              icon = "noctalia";
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
        darkMode = true;
        generateTemplatesForPredefined = true;
        matugenSchemeType = "scheme-fruit-salad";
        predefinedScheme = "Catppuccin";
        useWallpaperColors = false;
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
        animationSpeed = 1;
        avatarImage = "${config.home.homeDirectory}/.face";
        dimDesktop = false;
        forceBlackScreenCorners = false;
        radiusRatio = 0.2;
        screenRadiusRatio = 1;
        showScreenCorners = false;
      };
      hooks = {
        darkModeChange =
          let
            hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
              mode=$1

              if [ "$mode" = "true" ]; then
                switch-theme Dark
                vicinae vicinae://theme/set/vicinae-dark
              else
                switch-theme Light
                vicinae vicinae://theme/set/vicinae-light
              fi
            '';

          in
          "${lib.getExe hook_theme} $1";
        enabled = true;
        wallpaperChange = "";
      };
      location = {
        name = "Beijing; China";
        showWeekNumberInCalendar = true;
        use12hourFormat = false;
        useFahrenheit = false;
      };
      network = {
        wifiEnabled = true;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = true;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };
      notifications = {
        alwaysOnTop = true;
        criticalUrgencyDuration = 15;
        doNotDisturb = false;
        lastSeenTs = 0;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [ ];
        normalUrgencyDuration = 8;
        respectExpireTimeout = true;
      };
      osd = {
        alwaysOnTop = true;
        autoHideMs = 2000;
        enabled = true;
        location = "top_right";
        monitors = [ ];
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
      settingsVersion = 15;
      templates = {
        discord = false;
        discord_armcord = false;
        discord_dorion = false;
        discord_equibop = false;
        discord_lightcord = false;
        discord_vesktop = false;
        discord_webcord = false;
        enableUserTemplates = false;
        foot = false;
        fuzzel = false;
        ghostty = false;
        gtk = false;
        kcolorscheme = false;
        kitty = false;
        pywalfox = false;
        qt = false;
      };
      ui = {
        fontDefault = "Roboto";
        fontDefaultScale = 1;
        fontFixed = "DejaVu Sans Mono";
        fontFixedScale = 1;
        idleInhibitorEnabled = false;
        monitorsScaling = [ ];
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
            wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/Night_City.png";
          }
        ];
        randomEnabled = true;
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
      };
    };
  };

}
