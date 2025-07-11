{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        source = "$HOME/.cache/wal/colors-hyprland.conf";
        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
          special_scale_factor = 0.8;
        };

        master = {
          new_status = "master";
          new_on_top = 1;
          mfact = 0.5;
        };

        general = {
          border_size = 1;
          gaps_in = 3;
          gaps_out = 4;

          resize_on_border = true;

          "col.active_border" = "$color8";
          "col.inactive_border" = "$background";

          layout = "dwindle";
        };

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
            disable_while_typing = true;
            natural_scroll = true;
            scroll_factor = 0.2;
            clickfinger_behavior = false;
            middle_button_emulation = true;
            tap-to-click = true;
            drag_lock = false;
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

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 4;
          workspace_swipe_distance = 400;
          workspace_swipe_invert = true;
          workspace_swipe_min_speed_to_force = 30;
          workspace_swipe_cancel_ratio = 0.1;
          workspace_swipe_create_new = true;
          workspace_swipe_forever = false;
          #workspace_swipe_use_r = true #uncomment if wanted a forever create a new workspace with swipe right
        };

        group = {
          "col.border_active" = "$color15";

          groupbar = {
            "col.active" = "$color0";
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          disable_hyprland_qtutils_check = true;
          vfr = true;
          vrr = 0;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          # 禁用吞噬模式
          # 它会导致neovim使用yazi查看图片出现问题, kitty打开其他gui程序覆盖问题
          # enable_swallow = true
          # swallow_regex = ^(kitty)$
          # swallow_exception_regex = "^(kitty|yazi)$"
          focus_on_activate = false;
          initial_workspace_tracking = 0;
          middle_click_paste = false;
          disable_autoreload = false;
          lockdead_screen_delay = 1500;
        };

        #opengl {
        #  nvidia_anti_flicker = true
        #}

        binds = {
          workspace_back_and_forth = true;
          allow_workspace_cycles = true;
          pass_mouse_when_bound = false;
        };

        #could help when scaling and not pixelating
        xwayland = {
          force_zero_scaling = true;
        };

        # render section for hyprland >= v0.42.0
        render = {
          # explicit_sync = 0
          # explicit_sync_kms = 2
          # direct_scanout = false
        };

        cursor = {
          no_hardware_cursors = true;
          enable_hyprcursor = true;
          warp_on_change_workspace = true;
          no_warps = true;
        };

        ecosystem = {
          no_donation_nag = true;
          # enforce_permissions = true
        };

      };
    };
  };
}
