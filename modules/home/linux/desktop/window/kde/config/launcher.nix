{ config, lib, ... }:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    modules'.desktop.services.vicinae.enable = true;
  };
}
