{
  self,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  imports = self.importModule' ./.;

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
      kdePackages.applet-window-buttons6
      kdePackages.qtmultimedia
      kdePackages.qttools
      kdePackages.qtsvg
      kde-rounded-corners
    ];

  };
}
