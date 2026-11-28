{
  flake.aspects.desktop-base.nixos = {
    services = {
      sysprof.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
