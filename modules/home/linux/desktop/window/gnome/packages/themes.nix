{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    modules'.themes.auto = {
      enable = true;
      gtkTheme.enable = true;
    };

  };
}
