{ inputs, ... }:

final: prev:
let
  lib = inputs.nixpkgs.lib;

  overlays = [
    (final: prev: {
      sparkle = prev.callPackage ./pkgs/sparkle.nix { };
    })

    (final: prev: {
      clash-verge = inputs.nixpkgs.legacyPackages.${prev.system}.clash-verge;
    })

    (import ./pkgs/lix.nix)
  ];
in
lib.composeManyExtensions overlays final prev
