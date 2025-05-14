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
    home.packages = with pkgs; [
      gnome-tweaks
      dconf-editor
    ];

    modules.desktop.gnome.shell.packages = {
      appindicator.enable = true;
      auto-move-windows.enable = true;
      unite.enable = true;
      settingscenter.enable = true;
      just-perfection.enable = true;
      rounded-window-corners-reborn.enable = true;
    };

    programs.firefox.enableGnomeExtensions = true;
  };
}
