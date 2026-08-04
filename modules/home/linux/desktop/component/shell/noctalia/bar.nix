{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        bar = {
          capsuleOpacity = 1;
          density = "comfortable";
          exclusive = true;
          floating = false;
          hideOnOverview = false;
          marginHorizontal = 4;
          marginVertical = 4;
          monitors = [ ];
          outerCorners = true;
          position = "top";
          screenOverrides = [ ];
          showCapsule = false;
          showOutline = false;
          useSeparateOpacity = false;

          widgets = {
            center = [ "media" ];
            concave_edge_corners = false;
            end = [
              "tray"
              "notifications"
              "network"
              "bluetooth"
              "control-center"
              "session"
            ];
            font_family = "Monaco Nerd Font Mono";
            font_weight = 400;
            margin_ends = 0;
            padding = 15;
            panel_overlap = 0;
            radius = 18;
            radius_top_left = 0;
            radius_top_right = 0;
            scale = 1.1500000096857548;
            shadow = false;
            start = [ "workspaces" ];
            widget_spacing = 16;

            left = [
              {
                characterCount = 2;
                colorizeIcons = false;
                enableScrollWheel = true;
                followFocusedScreen = false;
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 0.80000000000000004;
                id = "Workspace";
                labelMode = "index";
                showApplications = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 1;
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
        };
      };
    };
  };
}
