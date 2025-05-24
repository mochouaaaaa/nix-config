{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    qt.style.name = "kvantum";

    modules.themes.auto = {
      enable = true;
      kdeTheme.enable = true;
    };

  };
}
