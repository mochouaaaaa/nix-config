{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.kde;
  kdeExtensions = inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.kdeExtensions;
in
{

  config = lib.mkIf cfg.enable {
    home.packages = with kdeExtensions; [
      applet-window-title
      thermal-monitor
      resources-monitor
      plasma-darwer
      net-speed
      kpple-menu
      kde-control-station
    ];

  };
}
