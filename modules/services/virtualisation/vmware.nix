{
  flake.aspects."services.virtualisation.vmware"."nixos" =
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
