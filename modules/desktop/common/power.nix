{
  flake.modules.nixos."desktop.common" = {
    services = {
      sysprof.enable = true;

      # "i2c-dev"  显示器亮度
      ddccontrol.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
