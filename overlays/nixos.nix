{ inputs, ... }:

(
  next: prev:
  let
    composed = inputs.nixpkgs.lib.composeManyExtensions [
      (import ./pkgs/mihomo-party-wrapper.nix)
    ];
  in
  composed next prev
  // {
    clash-verge = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.clash-verge;
  }
)
