_:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
in
{
  flake.modules.homeManager.core =
    {
      self,
      lib,
      homeManagerNixpkgsInput,
      ...
    }:
    lib.mkIf (homeManagerNixpkgsInput != null) {
      nixpkgs = {
        inherit config;
        overlays = [ self.overlays.home-manager ];
      };
    };

  flake.modules.nixos.core = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.nixos ];
    };
  };

  flake.modules.darwin.core = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.darwin ];
    };
  };
}
