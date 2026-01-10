{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages = with pkgs; [
      freerdp
    ];

    services.remmina = {
      enable = true;
      systemdService = {
        enable = false;
      };
    };

  };
}
