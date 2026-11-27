_:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
in
{
  flake.aspects."core"."homeManager" =
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

  flake.aspects."core"."nixos" = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.nixos ];
    };
  };

  flake.aspects."core"."darwin" = { self, ... }: {
    nixpkgs = {
      inherit config;
      overlays = [ self.overlays.darwin ];
    };
  };
}
