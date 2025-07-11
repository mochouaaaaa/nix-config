{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.component.waybar;
in
{

  imports = lib.importModule' ./.;

  config = lib.mkIf cfg.enable {

    xdg.configFile = {
    };

  };
}
