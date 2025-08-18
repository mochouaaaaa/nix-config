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

          gaps_workspaces = "$workspaceGaps";
          gaps_in = "$windowGapsIn";
          gaps_out = "$windowGapsOut";
          border_size = "$windowBorderSize";

          "col.active_border" = "$activeWindowBorderColour";
          "col.inactive_border" = "$inactiveWindowBorderColour";

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
