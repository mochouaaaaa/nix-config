{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgKde = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfgKde.enable {

    profiles.packages.steam.enable = lib.mkForce false;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
      krunner
      kwallet
    ];

  };
}
