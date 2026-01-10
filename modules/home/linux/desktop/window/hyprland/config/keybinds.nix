{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        "$mod" = "SUPER";
        "$term" = "kitty --single-instance";
        "$files" = "nautilus";

        bindel = cfg.settings.brightness ++ cfg.settings.volume;

        bindl = cfg.settings.media;

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

            "$mod ALT, O, exec, hyprctl setprop active opaque toggle" # disable opacity to active window

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
            "ALT, l, movefocus, r"
            "ALT, h, movefocus, l"
            "ALT, k, movefocus, u"
            "ALT, j, movefocus, d"
          ]
          ++ cfg.settings.screenshot
          ++ lib.optional (cfg.settings.clipboard != "") cfg.settings.clipboard
          ++ lib.optional (cfg.settings.launcher != "") cfg.settings.launcher
          ++ lib.optional (cfg.settings.lock != "") cfg.settings.lock
          ++ lib.optional (cfg.settings.shell-settings != "") cfg.settings.shell-settings;
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
