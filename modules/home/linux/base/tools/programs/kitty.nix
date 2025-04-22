{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages.kitty;
in
{
  config = lib.mkIf cfg.enable {
    modules.packages.kitty = {
      extraConfig = lib.mkAfter [
        "adjust_line_height 100%"
        "adjust_column_width 100%"
        "font_features Monaco Nerd Font Mono -liga -clig -calt"
      ];
    };
  };
}
