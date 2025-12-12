{
  pkgs,
  config,
  lib,
  ...
}:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    environment.systemPackages = [
      pkgs.rustdesk-flutter
    ];

    services.rustdesk-server = {
      enable = false;
      openFirewall = true;
      relay.enable = true;
      signal.enable = true;
      signal.relayHosts = [ "rs-ny.rustdesk.com:21116" ];
    };

  };
}
