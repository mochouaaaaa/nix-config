{
  flake.aspects.services.provides.nginx.nixos = {

    services.nginx = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
