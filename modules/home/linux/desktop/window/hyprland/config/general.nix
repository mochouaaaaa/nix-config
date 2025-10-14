{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {

        general = {
          layout = "dwindle";

          allow_tearing = false; # Allows `immediate` window rule to work

          gaps_workspaces = 8;
          gaps_in = 3;
          gaps_out = 3;
          border_size = 2;

          "col.active_border" = "rgba(ffffff59)";
          "col.inactive_border" = "rgba(255,255,255,0.15)";
        };

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = true;
        };

      };
    };
  };
}
