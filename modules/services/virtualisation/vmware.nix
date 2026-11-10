{
  flake.modules.nixos."services.virtualisation.vmware" =
    {
      pkgs,
      ...
    }:
    {
      virtualisation.vmware.host = {
        enable = true;
        package = pkgs.vmware-workstation;
      };
    };
}
