{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.waybar;
  cfg-settings = config.programs'.waybar'.settings;
in
{

  options.programs'.waybar'.settings = {
    modules-left = lib.mkOption rec {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of modules to be displayed on the left side of the bar.";
      apply = userValue: default ++ userValue;

    };
    modules-center = lib.mkOption rec {
      type = lib.types.listOf lib.types.str;
      default = [
        "custom/music"
      ];
      description = "List of modules to be displayed in the center of the bar.";
      apply = userValue: default ++ userValue;
    };
    modules-right = lib.mkOption rec {
      type = lib.types.listOf lib.types.str;
      default = [
        "battery"
        "tray"

        "pulseaudio"
        "pulseaudio#microphone"
        "clock"
      ];
      description = "List of modules to be displayed on the right side of the bar.";
      apply = userValue: default ++ userValue;
    };
  };

  config = lib.mkIf cfg.enable {

    programs.waybar = {
      settings = [
        {
          layer = "top";
          position = "top";
          height = 32;
          margin-left = 10;
          margin-right = 10;
          margin-top = 2;
          modules-left = cfg-settings.modules-left;
          modules-center = cfg-settings.modules-center;
          modules-right = cfg-settings.modules-right ++ [
            "custom/power"
          ];
          "hyprland/workspaces#icon" = {
            "disable-scroll" = true;
            "sort-by-name" = true;
            "format" = " {icon} ";
            "format-icons" = {
              # //"default"= "";
              "code" = "󰨞";
              "browser" = " ";
              "docs" = " ";
              "obs" = " ";
              "tencent" = " ";
              "steam" = " ";
              # // "6"= " ";
              # // "7"= " ";
              # // "8"= " ";
              # // "9"= "";
              # // "10"= "10";
            };
          };

          "niri/workspaces#icon" = {
            "format" = "{icon}";
            "format-icons" = {
              "code" = "󰨞";
              "browser" = " ";
              "docs" = " ";
              "tencent" = " ";
              "steam" = " ";
              "obs" = " ";
            };
          };

          "tray" = {
            "icon-size" = 21;
            "spacing" = 10;
          };
          "custom/music" = {
            "format" = "  {}";
            "escape" = true;
            "interval" = 5;
            "tooltip" = false;
            "exec" = "playerctl metadata --format='{{ title }}'";
            "on-click" = "playerctl play-pause";
            "max-length" = 50;
          };
          "clock" = {
            "timezone" = "Asia/Shanghai";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = " {:%d/%m/%Y}";
            "format" = " {:%H:%M}";
          };
          "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon}";
            "format-charging" = "";
            "format-plugged" = "";
            "format-alt" = "{icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };

          "pulseaudio#microphone" = {
            "format" = "{format_source}";
            "format-source" = "  {volume}%";
            "format-source-muted" = "";
            "on-click-right" = "volumectl -m -u toggle-mute";
            "on-click" = "pavucontrol -t 4";
            "on-scroll-up" = "volumectl -m -u up";
            "on-scroll-down" = "volumectl -m -u down";
            "tooltip-format" = "{source_desc} | {source_volume}%";
            "scroll-step" = 1;
          };
          "pulseaudio" = {
            "scroll-step" = 1;
            "format" = "{icon} {volume}%";
            "format-bluetooth" = "{icon} 󰂰 {volume}%";
            "format-muted" = "󰖁";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
                "󰕾"
                ""
              ];
              "ignored-sinks" = [ "Easy Effects Sink" ];
            };
            # "scroll-step"= 5.0;
            "on-click-right" = "volumectl toggle-mute";
            "on-click" = "pavucontrol -t 3";
            "on-scroll-up" = "volumectl up";
            "on-scroll-down" = "volumectl down";
            "tooltip-format" = "{icon} {desc} | {volume}%";
            "smooth-scrolling-threshold" = 1;
          };

          "custom/hyprlock" = {
            tooltip = false;
            on-click = "sh -c '(sleep 0.5s; hyprlock)' & disown";
            format = "";
          };
          "custom/swaylock" = {
            on-click = "sh -c 'Lock' % disown";
            format = "";
          };
          "custom/power" = {
            icon-size = 20;
            on-click = "wlogout -C $HOME/.config/wlogout/style.css -l $HOME/.config/wlogout/layout -b 4 -B 400 -T 400";
            tooltip = false;
            format = "⏻ ";
          };
        }
      ];

    };
  };
}
