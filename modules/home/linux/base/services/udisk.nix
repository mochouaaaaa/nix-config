{ config, lib, ... }:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    # auto mount usb drives
    services = {
      udiskie.enable = true;
      syncthing.enable = true;
    };

  };
}
