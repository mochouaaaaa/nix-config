{
  flake.aspects.services.provides.virtualisation.vmware.nixos =
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
