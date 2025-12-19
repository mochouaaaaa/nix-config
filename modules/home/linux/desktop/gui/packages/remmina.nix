{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.programs.desktop.enable) {

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
