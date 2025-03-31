{
  lib,
  pkgs,
  ...
}: {
  boot.initrd.kernelModules = ["amdgpu"];

  services.xserver = {
    enable = lib.mkDefault true;
    videoDrivers = ["amdgpu"];
  };

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    # amdgpu-firmware
  ];

  environment.systemPackages = with pkgs; [
    blender-hip
    clinfo
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}
