{ inputs, ... }:

(
  next: prev:
  let
    composed = inputs.nixpkgs.lib.composeManyExtensions [
    ];
  in
  composed next prev
  // {
    # xx = xx;
  }
)
