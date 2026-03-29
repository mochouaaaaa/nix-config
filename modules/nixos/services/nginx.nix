{ lib, config, ... }:
let
  cfg = config.profiles.services.nginx;
in
{

  options.profiles.services.nginx = {
    enable = lib.mkEnableOption "Enable Nginx Server";
  };

  config = lib.mkIf cfg.enable {

    services.nginx = {
      enable = true;
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        53
      ];
    };

  };
}
