{
  flake.aspects.desktop-base.nixos = {
    services.accounts-daemon.enable = true;
  };
}
