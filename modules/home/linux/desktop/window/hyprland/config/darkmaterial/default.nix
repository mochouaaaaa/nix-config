{ lib, config, ... }:
let
  cfg = config.programs.dankMaterialShell;
  cfgHyprland = config.modules'.desktop.hyprland;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.enable && cfgHyprland.enable) { };
}
