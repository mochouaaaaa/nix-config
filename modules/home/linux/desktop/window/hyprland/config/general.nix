{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {

        general = {
          layout = "scrolling"; # "dwindle"

          allow_tearing = false; # Allows `immediate` window rule to work

          gaps_workspaces = 8;
          gaps_in = 3;
          gaps_out = 3;
          border_size = 0;

          "col.active_border" = "0x00000000";
          "col.inactive_border" = "0x00000000";
        };

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = true;
        };

        scrolling = {
          explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
          column_width = 0.51;
        };

      };
    };
  };
}
