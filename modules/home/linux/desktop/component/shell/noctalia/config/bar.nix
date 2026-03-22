{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.noctalia-shell;
in
{

  config = lib.mkIf (cfg.enable) {

    programs.noctalia-shell.settings = {
      bar = {
        position = "top";
        monitors = [ ];
        density = "comfortable";
        showOutline = false;
        showCapsule = false;
        capsuleOpacity = 1;
        backgroundOpacity = lib.mkDefault 0.78;
        useSeparateOpacity = false;
        floating = false;
        marginVertical = 4;
        marginHorizontal = 4;
        outerCorners = true;
        exclusive = true;
        hideOnOverview = false;
        widgets = {
          left = [
            {
              characterCount = 2;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = true;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              showApplications = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
          ];
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
              defaultSettings = {
                hideInactive = false;
                removeMargins = false;
              };
              id = "plugin:privacy-indicator";
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
              hidePassive = false;
              id = "Tray";
              pinned = [ ];
            }
            {
              compactMode = false;
              diskPath = "/";
              id = "SystemMonitor";
              showCpuTemp = false;
              showCpuUsage = false;
              showDiskUsage = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = true;
              showMemoryUsage = true;
              showNetworkStats = true;
              showSwapUsage = false;
              useMonospaceFont = true;
              usePrimaryColor = true;
            }
            {
              id = "KeepAwake";
            }
            {
              id = "plugin:screen-recorder";
            }
            {
              displayMode = "alwaysShow";
              id = "Network";
            }
            {
              displayMode = "onhover";
              id = "Bluetooth";
            }
            {
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "ease-in-out-control-points-filled";
              id = "ControlCenter";
              useDistroLogo = false;
            }
            {
              customFont = "";
              formatHorizontal = "yyyy-MM-dd ddd HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = true;
            }
          ];
        };
        screenOverrides = [ ];
      };
    };
  };
}
