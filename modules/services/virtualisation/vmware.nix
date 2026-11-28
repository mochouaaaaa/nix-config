{
  flake.aspects.services.provides.virtualisation.provides.vmware.nixos =
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
