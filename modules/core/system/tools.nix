{
  flake.aspects."core"."nixos" = { pkgs, ... }: {
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
