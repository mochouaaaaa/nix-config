{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_zen.vmware
  ];

  virtualisation = {
    vmware = {
      host = {
        enable = false;
        package = pkgs.vmware-workstation;
      };
      guest = {enable = true;};
    };
  };
}
