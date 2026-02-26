{
  pkgs,
  ...
}:
{
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  hardware = {
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
      overdrive.enable = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    clinfo
    pkgsRocm.blender
  ];

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}
