{
  flake.modules.nixos."hardware.firmware" = {
    hardware.uinput.enable = true;
  };

  flake.modules.nixos."desktop.common" = { self, ... }: {
    imports = [ self.modules.nixos."hardware.firmware" ];
  };
}
