{ self, ... }:
{
  flake.modules.nixos."desktop.base" = {
    imports = [
      self.modules.nixos.appearance
      self.modules.nixos."security.desktop"
    ];

    services.geoclue2.enable = true;

    environment.systemPackages = [ self.inputs.nixpkgs.legacyPackages.x86_64-linux.uwsm ];
  };
}
