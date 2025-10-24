{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfgSettings = config.wayland.windowManager.hyprland.custom_settings;
in
{

  options.wayland.windowManager.hyprland = {
    custom_settings = {
      media = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default =
          let
            playerctl = "${lib.getExe pkgs.playerctl}";
          in
          [
            ", XF86AudioPlay, exec, ${playerctl} play-pause"
            ", XF86AudioStop, exec, ${playerctl} pause"
            ", XF86AudioPrev, exec, ${playerctl} previous"
            ", XF86AudioNext, exec, ${playerctl} next"
            ", XF86audioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];
      };
      brightness = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
        ];
      };
      volume = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ", XF86Audioraisevolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86Audiolowervolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
      };
      shell-settings = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      lock = lib.mkOption {
        type = lib.types.str;
        default = "hyprlock";
      };
      clipboard = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      launcher = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      screenshot = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "$mod CTRL, S, exec, grimblast -n -o -e 5000 --freeze copysave active"
          "$mod CTRL, A, exec, grimblast -n -o -e 5000 --freeze copysave area"
        ];
      };
    };

  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {

      settings = {
        "$mod" = "SUPER";
        "$term" = "kitty";
        "$files" = "nautilus";

        bindel = cfgSettings.brightness ++ cfgSettings.volume;

        bindl = cfgSettings.media;

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
          ]
          ++ cfgSettings.screenshot
          ++ lib.optional (cfgSettings.clipboard != "") cfgSettings.clipboard
          ++ lib.optional (cfgSettings.launcher != "") cfgSettings.launcher
          ++ lib.optional (cfgSettings.lock != "") cfgSettings.lock
          ++ lib.optional (cfgSettings.shell-settings != "") cfgSettings.shell-settings;
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };

  };
}
