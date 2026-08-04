{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        widget = {
          clock = {
            font_family = "Maple Mono CN";
            font_weight = 200;
            format = "{:%-m月%-d日 周%a %H:%M}";
          };
          media = {
            hide_when_no_media = true;
          };
        };
        bar = {
          order = [ "widgets" ];

          widgets = {
            concave_edge_corners = false;
            font_family = "Maple Mono CN";
            font_weight = 400;
            margin_ends = 0;
            padding = 30;
            panel_overlap = 0;
            radius = 18;
            radius_top_left = 0;
            radius_top_right = 0;
            scale = 1.1500000096857548;
            shadow = false;

            start = [ "workspaces" ];
            widget_spacing = 16;
            center = [ "media" ];
            end = [
              "tray"
              "notifications"
              "network"
              "bluetooth"
              "control-center"
              "clock"
              "session"
            ];

          };

        };

      };
    };
  };
}
