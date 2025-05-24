{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    # auto dark/light theme
    modules.themes.auto = {
      enable = true;
      gtkTheme.enable = true;
    };

  };
}
