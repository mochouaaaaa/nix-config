{
  flake.aspects.services.provides.avahi.nixos = {

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

  };
}
