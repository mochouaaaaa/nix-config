{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {

      settings = {
        "$mod" = "SUPER";
        "$term" = "kitty";
        "$files" = "nautilus";

        bindel = [
          ", XF86Audioraisevolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86Audiolowervolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindl = [
          ", XF86audiomute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        binde = [
          # Resize windows
          "CTRL SHIFT, left, resizeactive,-50 0"
          "CTRL SHIFT, right, resizeactive,50 0"
          "CTRL SHIFT, up, resizeactive,0 -50"
          "CTRL SHIFT, down, resizeactive,0 50"
        ];

        bind =
          let
            killactive = pkgs.writeShellScriptBin "killactive" ''
              if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
                  xdotool getactivewindow windowunmap
              else
                  hyprctl dispatch killactive ""
              fi
            '';
          in
          [
            # "$mod CTRL, q, exec, Lock" # Lock screen
            "$mod, Q, exec, ${lib.getExe killactive}"
            "CTRL ALT, return, fullscreen"
            "$mod CTRL, F, togglefloating,"

            "$mod CTRL, T, exec, $term" # Launch terminal
            "$mod CTRL, E, exec, nautilus" # Launch file manager

            # "$mod ALT, R, exec, bash refresh" # Refresh waybar, swaync, rofi

            # "$mod SHIFT CTRL, I, exec, bash WallpaperSelect.sh" # Select wallpaper to apply
            "$mod ALT, O, exec, hyprctl setprop active opaque toggle" # disable opacity to active window

            # Master Layout
            # $mod CTRL, D, layoutmsg, removemaster
            # $mod, I, layoutmsg, addmaster
            # $mod, M, exec, hyprctl dispatch splitratio 0.3
            # $mod, P, pseudo, # dwindle
            # $mod CTRL, Return, layoutmsg, swapwithmaster

            # group
            "$mod, G, togglegroup"
            "$mod CTRL, tab, changegroupactive" # change focus to another window

            # Cycle windows if floating bring to top
            "ALT, tab, cyclenext"
            "ALT, tab, bringactivetotop"

            # screenshot with swappy (another screenshot tool)
            # "$mod CTRL, S, exec, screenshot --active"
            # "$mod CTRL, A, exec, screenshot --area"

            # Move focus with mainMod + arrow keys
            "ALT, l, movefocus, l"
            "ALT, h, movefocus, r"
            "ALT, k, movefocus, u"
            "ALT, j, movefocus, d"

          ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };

  };
}
