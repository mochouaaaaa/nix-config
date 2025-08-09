{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgKde = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfgKde.enable {

    modules'.packages.steam.enable = lib.mkForce false;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];

  };
}
