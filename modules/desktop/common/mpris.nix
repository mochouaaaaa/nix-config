{
  flake.aspects."desktop.user".homeManager = {
    services.mpris-proxy.enable = true;
  };
}
