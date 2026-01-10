{
  lib,
  inputs,
  self,
  ...
}:
let

  mkForceRecursive =
    attrset:
    lib.mapAttrs (
      name: value:
      if lib.isAttrs value && !lib.isDerivation value then mkForceRecursive value else lib.mkForce value
    ) attrset;

in
{

  flake.overlays.lib = final: prev: {
    inherit mkForceRecursive;
  };

  perSystem._module.args = {
    lib = inputs.nixpkgs.lib.extend (
      final: prev:
      (
        self.overlays.lib final prev
        // {
          hm = inputs.home-manager.lib.hm;
        }
      )
    );
  };
}
