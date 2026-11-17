{
  flake.modules.nixos."desktop.base" = {
    services.accounts-daemon.enable = true;
  };
}
