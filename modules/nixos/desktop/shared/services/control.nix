{ lib, config, ... }:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf cfg.enable {

    services = {
      dbus.implementation = "broker";
      sysprof.enable = true;

      # "i2c-dev"  显示器亮度
      ddccontrol.enable = true;

      touchegg = {
        enable = false;
      };

      # for power management
      power-profiles-daemon = {
        enable = true;
      };
      upower.enable = true;
    };

  };

}
