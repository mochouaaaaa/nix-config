{ inputs, ... }:

(
  next: prev:
  let
    composed = inputs.nixpkgs.lib.composeManyExtensions [
      (import ./pkgs/mihomo-party-warpper.nix)
    ];
  in
  composed next prev
  // {
    # xx = xx;
  }
)
