{ self, ... }:
{
  flake.modules.nixos."desktop.hardware" = {
    imports = [
      self.modules.nixos.hardware
      self.modules.nixos."hardware.desktop"
    ];
  };
}
