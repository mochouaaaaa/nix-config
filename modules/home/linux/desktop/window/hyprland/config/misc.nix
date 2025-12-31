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

        misc = {
          disable_splash_rendering = true;
          # disable_hyprland_qtutils_check = true;
          # 禁用吞噬模式
          # 它会导致neovim使用yazi查看图片出现问题, kitty打开其他Tui程序覆盖问题
          # enable_swallow = true
          # swallow_regex = ^(kitty)$
          # swallow_exception_regex = "^(kitty|yazi)$"
          initial_workspace_tracking = 0;
          disable_autoreload = false;
          lockdead_screen_delay = 1500;

          vfr = true;
          vrr = 1;

          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;

          disable_hyprland_logo = true;
          force_default_wallpaper = 0;

          # new_window_takes_over_fs = 2;
          allow_session_lock_restore = true;
          middle_click_paste = false;
          focus_on_activate = true;
          session_lock_xray = true; # 0.50

          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;

          background_color = "rgba(f5f5f5cc)";
        };

      };
    };
  };
}
