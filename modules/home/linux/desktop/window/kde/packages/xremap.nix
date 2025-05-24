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

    services.xremap.withKDE = lib.mkForce true;

  };
}
