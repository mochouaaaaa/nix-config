{
  flake.modules.homeManager."desktop.cosmic" = { cosmicLib, ... }: {

    wayland.desktopManager.cosmic.compositor = {
      active_hint = true;
      autotile = false;
      autotile_behavior = cosmicLib.cosmic.mkRON "enum" "PerWorkspace";
      cursor_follows_focus = false;
      edge_snap_threshold = 10;
      focus_follows_cursor = false;
      focus_follows_cursor_delay = 250;
      workspaces = {
        workspace_mode = cosmicLib.cosmic.mkRON "enum" "OutputBound";
        workspace_layout = cosmicLib.cosmic.mkRON "enum" "Vertical";
        action_on_typing = cosmicLib.cosmic.mkRON "enum" "r#None";
        workspace_wraparound = cosmicLib.cosmic.mkRON "enum" "false";
      };
      xkb_config = {
        rules = "";
        model = "pc104";
        layout = "us";
        variant = "";
        options = cosmicLib.cosmic.mkRON "optional" "terminate:ctrl_alt_bksp";
        repeat_delay = 200;
        repeat_rate = 50;
      };
    };
  };
}
