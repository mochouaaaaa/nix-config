{ config, lib, ... }:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    # auto mount usb drives
    services = {
      udiskie.enable = true;
      syncthing.enable = true;
    };

  };
}
