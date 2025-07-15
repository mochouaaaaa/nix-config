{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.waybar;
in
{

  imports = lib.importModule' ./.;

  config = lib.mkIf cfg.enable {

    xdg.configFile = {
    };

  };
}
