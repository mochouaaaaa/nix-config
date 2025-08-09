{ config, lib, ... }:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
    };
  };
}
