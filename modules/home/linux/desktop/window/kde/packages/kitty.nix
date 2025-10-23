{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    modules'.packages.terminal.kitty.extraConfig = [
      # "hide_window_decorations yes"
    ];

  };
}
