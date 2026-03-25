{
  pkgs,
  lib,
  config,
  ...
}:
{

  systemd.packages = [ pkgs.uwsm ];
  environment = {
    localBinInPath = true;
    systemPackages =
      with pkgs;
      [
        uwsm
        # system call monitoring
        lsof # list open files

        # system tools
        # chntpw
        psmisc # killall/pstree/prtstat/fuser/...
        # lm_sensors # for `sensors` command
        # ethtool
        pciutils # lspci
        usbutils # lsusb
        # hdparm # for disk performance, command
        # dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
        # parted
      ]
      ++ lib.optionals (!config.profiles.wsl.enable) [ ntfs3g ];
  };

}
