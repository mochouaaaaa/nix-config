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

        input = {
          kb_layout = "cn";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          repeat_rate = 40;
          repeat_delay = 200;

          sensitivity = 0; # mouse sensitivity
          numlock_by_default = true;
          left_handed = false;
          follow_mouse = true;
          float_switch_override_focus = false;

          touchpad = {
            clickfinger_behavior = true; # 两指右键
            middle_button_emulation = true;
            tap-to-click = true;
            drag_lock = false;
            drag_3fg = 1; # 三指拖动 0.50
            natural_scroll = true;
            disable_while_typing = true;
            scroll_factor = 1.15;
          };

          # below for devices with touchdevice ie. touchscreen
          touchdevice = {
            enabled = true;
          };

          # below is for table see link above for proper variables
          tablet = {
            transform = 0;
            left_handed = 0;
          };
        };

        binds = {
          workspace_back_and_forth = true;
          allow_workspace_cycles = true;
          pass_mouse_when_bound = false;
          scroll_event_delay = 0;
        };

        gestures = {
          # workspace_swipe = true;
          workspace_swipe_distance = 700;
          # workspace_swipe_fingers = "$workSpaceSwipeFingers"; # 4
          workspace_swipe_cancel_ratio = 0.15;
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };

      };
    };
  };
}
