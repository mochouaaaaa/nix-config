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
      inputs,
      osConfig,

      homeManagerNixpkgsInput,
      ...
    }:
    {

      config = {
        nixpkgs = lib.optionalAttrs (osConfig == null || !osConfig.home-manager.useGlobalPkgs) {
          inherit config;
          overlays = [ self.overlays.home-manager ];
        };

        _module.args = lib.optionalAttrs (homeManagerNixpkgsInput != null) {
          pkgsPath = inputs.${homeManagerNixpkgsInput}.outPath;
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
