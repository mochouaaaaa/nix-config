{
  flake.modules.nixos.core = { pkgs, ... }: {
    environment = {
      localBinInPath = true;
      systemPackages = with pkgs; [
        uwsm
        lsof # list open files
        psmisc # killall/pstree/prtstat/fuser/...
        pciutils # lspci
        usbutils # lsusb
        ntfs3g
      ];
    };
  };
}
