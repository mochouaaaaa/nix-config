{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox.enableGnomeExtensions = true;
  };
}
