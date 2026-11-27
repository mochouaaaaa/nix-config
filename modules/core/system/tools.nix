{
  flake.aspects.core.provides.tools.nixos = { pkgs, ... }: {
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
