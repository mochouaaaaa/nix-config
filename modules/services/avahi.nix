{
  flake.modules.nixos."services.base" = {

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

  };
}
