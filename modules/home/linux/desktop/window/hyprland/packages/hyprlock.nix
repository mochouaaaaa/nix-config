{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfg_lock = config.modules'.desktop.component.hyprlock;
in
{
  options.modules'.desktop.component.hyprlock = {
    enable = lib.mkEnableOption "Waybar status bar" // {
      default = false;
    };
  };

  config = lib.mkIf (cfg.enable || cfg_lock.enable) {
    home.packages = with pkgs; [
      (writeShellScriptBin "Lock" ''
        hyprlock
      '')

      (writeShellScriptBin "Dpms" ''

        if pgrep hyprlock > /dev/null; then
            hyprctl dispatch dpms off
        fi
      '')
    ];

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          grace = 0;
          disable_loading_bar = false;
          ignore_empty_input = true;
        };
        background = {
          path = "~/.current_wallpaper";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.35;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };
        input-field = {
          size = "200, 80";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(18, 18, 18, 18)";
          inner_color = "rgba(18,18,18,0.5)";
          font_color = "rgba(181, 181, 181,1)";
          fade_on_empty = true;
          font_family = "Monaco Nerd Font";
          invert_numlock = true;
          placeholder_text = "🔒";
          fail_text = "❌";
          hide_input = false;
          position = "0, -300";
          halign = "center";
          valign = "center";
        };
        label = {
          text = ''cmd[update:1000] echo -e "$(date +"%I")"'';
          color = "rgba(255, 255, 255, 1)";
          shadow_size = 3;
          shadow_color = "rgb(0,0,0)";
          shadow_boost = 1.2;
          font_size = 200;
          font_family = "Monaco Nerd Font";
          position = "0, -220";
          halign = "center";
          valign = "top";
        };
      };
      extraConfig = ''
        label {
           text = cmd[update:1000] echo -e "$(date +"%M")"
           color = rgba(255, 255, 255, 1)
           font_size = 200
           font_family = Monaco Nerd Font
           position = 0, -470
           halign = center
           valign = top
        }
        label {
           monitor=eDP-1
           text = cmd[update:1000] echo -e "$(date +"%d, %b %A")"
           color = rgba(255, 255, 255, 1)
           font_size = 13
           font_family = Monaco Nerd Font
           position = 0, -550
           halign = center
           valign = center
        }
        label {
            monitor=DP-3
            text = cmd[update:1000] echo -e "$(date +"%d, %b %A")"
            color = rgba(255, 255, 255, 1)
            font_size = 14
            font_family = Monaco Nerd Font
            position = 10, -500
            halign = center
            valign = center
        }
      '';
    };
  };
}
