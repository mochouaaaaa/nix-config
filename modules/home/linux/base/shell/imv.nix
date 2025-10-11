{ config, lib, ... }:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    programs = {
      imv = {
        enable = true;
      };
    };

    xdg.mimeApps.defaultApplications = {
      "image/*" = [ "imv-dir.desktop" ];
      "image/gif" = [ "imv-dir.desktop" ];
      "image/jpeg" = [ "imv-dir.desktop" ];
      "image/png" = [ "imv-dir.desktop" ];
      "image/webp" = [ "imv-dir.desktop" ];
    };

  };
}
