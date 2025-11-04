{
  lib,
  config,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfgHyprland.enable && cfgNoctalia.enable) {

  };
}
