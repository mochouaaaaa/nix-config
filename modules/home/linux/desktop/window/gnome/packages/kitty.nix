{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{

  config = lib.mkIf cfg.enable {
    modules'.packages.terminal.kitty.extraConfig = lib.mkAfter [
      "background_opacity 1"
    ];

  };
}
