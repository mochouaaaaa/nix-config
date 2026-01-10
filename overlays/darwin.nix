{ inputs, ... }:

final: prev:
let
  lib = inputs.nixpkgs.lib;

  overlays = [
    # 3️⃣ lix stable 工具集
    (import ./pkgs/lix.nix)
  ];
in
lib.composeManyExtensions overlays final prev
