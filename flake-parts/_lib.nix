{
  lib,
  inputs,
  self,
  ...
}:
let
  importModule' =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );
  # path:
  # builtins.readDir path
  # |> lib.attrNames
  # |> lib.subtractLists [ "default.nix" ]
  # |> map (n: path + "/${n}");

  mkForceRecursive =
    attrset:
    lib.mapAttrs (
      name: value:
      if lib.isAttrs value && !lib.isDerivation value then mkForceRecursive value else lib.mkForce value
    ) attrset;

in
{

  flake.overlays.lib = final: prev: {
    inherit importModule' mkForceRecursive;
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
