{ lib, config, ... }:
let
  cfg = config.programs.dankMaterialShell;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.enable) { };
}
