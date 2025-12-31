{ inputs, ... }:

(
  final: prev:
  let
    composed = inputs.nixpkgs.lib.composeManyExtensions [
      # (import ./pkgs/mihomo-party-wrapper.nix)
    ];
  in
  composed final prev
  // {
    clash-verge = inputs.nixpkgs.legacyPackages.${prev.system}.clash-verge;
    sparkle = prev.callPackage ./pkgs/sparkle.nix { };
  }
)
