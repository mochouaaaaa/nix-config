{
  flake.modules.nixos.core = { pkgs, ... }: {
    environment = {
      localBinInPath = true;
      systemPackages = with pkgs; [
        lsof
        psmisc
        pciutils
        usbutils
        ntfs3g
      ];
    };
  };
}
