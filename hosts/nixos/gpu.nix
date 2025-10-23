{
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    blender-hip
    clinfo
  ];

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}
