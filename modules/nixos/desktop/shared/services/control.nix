{ lib, config, ... }:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf cfg.enable {

    # "i2c-dev"  显示器亮度
    services.ddccontrol.enable = true;

    services = {
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
