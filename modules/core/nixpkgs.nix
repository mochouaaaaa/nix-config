_:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
    tarball-ttl = 0;
  };

in
{

  flake.modules.homeManager.nixpkgs = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.home-manager ];
    };
  };

  flake.modules.nixos.core =
    { self, username, ... }:
    {
      home-manager.users.${username}.imports = [
        self.modules.homeManager.nixpkgs
      ];

      nixpkgs = {
        inherit config;
        overlays = [ self.overlays.nixos ];
      };

    };

  flake.modules.darwin.core = { self, username, ... }: {
    home-manager.users.${username}.imports = [
      self.modules.homeManager.nixpkgs
    ];

    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.darwin ];
    };
  };
}
