{
  lib,
  inputs,
  self,
  ...
}:
let

  recursiveField =
    attrset: fn:
    lib.mapAttrs (
      name: value:
      if lib.isAttrs value && !lib.isDerivation value then recursiveField value fn else fn value
    ) attrset;

  # mkForceRecursive
  mkForceRecursive = attrset: recursiveField attrset lib.mkForce;

  # mkDefaultRecursive
  mkDefaultRecursive = attrset: recursiveField attrset lib.mkDefault;

in
{

  flake.overlays.lib = final: prev: {
    inherit mkForceRecursive mkDefaultRecursive;
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
