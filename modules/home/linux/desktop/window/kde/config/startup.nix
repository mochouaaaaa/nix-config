{ config, lib, ... }:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
    };
  };
}
