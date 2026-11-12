{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;

  # Overlays shared by NixOS, Darwin, and standalone Home Manager.
  common = lib.composeManyExtensions [
    inputs.nur.overlays.default
    inputs.vscode-extensions.overlays.default
    (_final: prev: {
      nodejs = prev.nodejs_24;
      nodejs_22 = prev.nodejs_24;
      inherit (prev) nodejs_24;
    })
  ];
in
{
  flake.overlays = {
    default = _final: _prev: { };

    # NixOS and its embedded Home Manager share the system package set.
    nixos = lib.composeManyExtensions [
      common
      (import ../../pkgs/lix.nix)
    ];

    # nix-darwin and its embedded Home Manager share the system package set.
    darwin = lib.composeManyExtensions [
      common
      (import ../../pkgs/lix.nix)
    ];

    # Standalone Home Manager uses its own package set.
    home-manager = common;
  };
}
