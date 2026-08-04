{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        wallpaper = {
          automationEnabled = false;
          directory = "/home/mochou/Pictures/Wallpapers";
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = "#1e1e2e";
          fillMode = "crop";
          fill_mode = "fit";
          hideWallpaperFilenames = false;
          monitorDirectories = [ ];
          overviewEnabled = false;
          panelPosition = "top_center";
          randomIntervalSec = 300;
          recursiveSearch = true;
          setWallpaperOnAllMonitors = true;
          solidColor = "#1a1a2e";
          transitionDuration = 2500;
          transitionEdgeSmoothness = 0.14999999999999999;
          transitionType = "random";
          useSolidColor = false;
          useWallhaven = false;
          wallhavenApiKey = "";
          wallhavenCategories = "111";
          wallhavenOrder = "desc";
          wallhavenPurity = "100";
          wallhavenQuery = "";
          wallhavenRatios = "";
          wallhavenResolutionHeight = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenSorting = "relevance";
          wallpaperChangeMode = "random";
          default = {
            path = "/home/mochou/Pictures/Wallpapers/Dynamic-Wallpapers/Light/Summer-Scene-Light.png";
          };
        };
      };
    };
  };
}
