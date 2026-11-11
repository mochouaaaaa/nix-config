{
  flake.modules.nixos."desktop.common" = {
    services = {
      sysprof.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
