{ config, lib, ... }:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    # auto mount usb drives
    services = {
      udiskie.enable = true;
      syncthing.enable = true;
    };

  };
}
