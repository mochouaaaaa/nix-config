{
  pkgs,
  ...
}:
{

  environment.systemPackages = [
    pkgs.rustdesk-flutter
  ];
  #
  # users = {
  #   users.rustdesk = {
  #     description = "System user for RustDesk";
  #     isSystemUser = true;
  #     group = "rustdesk";
  #   };
  #   groups.rustdesk = { };
  # };
  #
  # networking.firewall = {
  #   allowedTCPPorts = [
  #     21115
  #     21116
  #     21117
  #     21118
  #     21119
  #   ];
  #   allowedUDPPorts = [ 21116 ];
  # };

  services.rustdesk-server = {
    enable = false;
    openFirewall = true;
    relay.enable = true;
    signal.enable = true;
    signal.relayHosts = [ "rs-ny.rustdesk.com:21116" ];
  };
}
