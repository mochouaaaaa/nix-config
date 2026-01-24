{ pkgs, ... }:
{

  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      # system call monitoring
      coreutils
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
    ];
  };

}
