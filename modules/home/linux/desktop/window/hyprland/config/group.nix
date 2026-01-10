{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        group = {

          "col.border_active" = "rgba(255,255,255,0.35)";
          "col.border_inactive" = "rgba(255,255,255,0.15)";
          "col.border_locked_active" = "rgba(255,255,255,0.35)";
          "col.border_locked_inactive" = "rgba(255,255,255,0.15)";

          groupbar = {
            font_family = "JetBrains Mono NF";
            font_size = 15;
            gradients = true;
            gradient_round_only_edges = false;
            gradient_rounding = 5;
            height = 25;
            indicator_height = 0;
            gaps_in = 3;
            gaps_out = 3;

            text_color = "rgb(ffffff)";
            "col.active" = "rgba(007aff59)";
            "col.inactive" = "rgba(007aff26)";
            "col.locked_active" = "rgba(007aff40)";
            "col.locked_inactive" = "rgba(007aff15)";
          };

        };
      };
    };
  };
}
