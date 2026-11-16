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
      osConfig,
      ...
    }:
    {

      config = lib.mkIf (osConfig == null || !osConfig.home-manager.useGlobalPkgs) {
        nixpkgs = {
          inherit config;
          overlays = [ self.overlays.home-manager ];
        };
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
