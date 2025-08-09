{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    modules'.packages.kitty.extraConfig = lib.mkAfter [
      # "hide_window_decorations yes"
    ];

  };
}
