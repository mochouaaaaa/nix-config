{
  flake.modules.nixos."desktop.base" = {
    services = {
      sysprof.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
