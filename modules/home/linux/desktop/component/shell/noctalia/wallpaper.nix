{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          directory_dark = "";
          directory_light = "";
          edge_smoothness = 0.30000001192092896;
          enabled = true;
          fill_color = "";
          fill_mode = "fit";
          per_monitor_directories = false;
          transition = [
            "fade"
            "wipe"
            "disc"
            "stripes"
            "zoom"
            "honeycomb"
          ];
          transition_duration = 1500.0;
          transition_on_startup = false;

          automation = {
            enabled = false;
            interval_seconds = 1800;
            order = "random";
            recursive = true;
          };

        };
      };
    };
  };
}
