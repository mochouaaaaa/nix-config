_:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
in
{
  flake.aspects.core.provides.nixpkgs.homeManager =
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

  flake.aspects.core.provides.nixpkgs.nixos = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.nixos ];
    };
  };

  flake.aspects.core.provides.nixpkgs.darwin = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.darwin ];
    };
  };
}
