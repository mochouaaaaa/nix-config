{
  lib,
  inputs,
  self,
  ...
}:
let
  importModule' =
    path:
    builtins.readDir path
    |> lib.attrNames
    |> lib.subtractLists [ "default.nix" ]
    |> map (n: path + "/${n}");

in
{

  flake.overlays.lib = final: prev: {
    inherit importModule';
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
