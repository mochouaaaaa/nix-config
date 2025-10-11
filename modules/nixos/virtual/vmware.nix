{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.virtual;
in
{
  config = lib.mkIf (cfg.vmware.enable && config.programs.desktop.enable) {
    environment.systemPackages = with pkgs; [
      linuxKernel.packages.linux_zen.vmware
    ];

    virtualisation = {
      vmware = {
        host = {
          enable = false;
          package = pkgs.vmware-workstation;
        };
        guest = {
          enable = true;
        };
      };
    };
  };
}
