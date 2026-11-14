{
  flake.modules.nixos."services.avahi" = {

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

  };
}
