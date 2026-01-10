{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.virtual;
in
{
  config = lib.mkIf (cfg.vmware.enable && config.profiles.desktop.enable) {
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
