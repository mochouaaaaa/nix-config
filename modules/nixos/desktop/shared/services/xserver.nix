{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.profiles.desktop.enable) {

    services.xserver = {
      enable = lib.mkForce true;
      excludePackages = with pkgs; [
        xterm
      ];
    };

  };
}
