{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.enable && cfgNoctalia.enable) {

  };
}
