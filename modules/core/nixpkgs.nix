_:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
    tarball-ttl = 0;
  };

in
{

  flake.modules.nixos.core = { self, username, ... }: {

    nixpkgs = {
      config = config;
      overlays = [ self.overlays.nixos ];
    };

    home-manager.users.${username} = {
      nixpkgs = {
        config = config;
        overlays = [ self.overlays.home-manager ];
      };
    };
  };

  flake.modules.darwin.core = { self, ... }: {
    nixpkgs = {
      config = config;
      overlays = [ self.overlays.darwin ];
    };
  };
}
