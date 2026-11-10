{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
{
  flake.overlays = {
    default = final: prev: {
    };

    # NixOS 专用 overlay
    nixos = lib.composeManyExtensions [
      (import ../../pkgs/lix.nix)
    ];

    # Darwin 专用 overlay
    darwin = final: prev: {
    };

    # Home Manager 专用 overlay（如果确实需要独立于系统 pkgs）
    home-manager = lib.composeManyExtensions [
      inputs.nur.overlays.default
      inputs.vscode-extensions.overlays.default
      (final: prev: {
        nodejs = prev.nodejs_24; # 或 nodejs_22，选一个
        nodejs_22 = prev.nodejs_24; # 如果某些包硬编码了 nodejs_22
        nodejs_24 = prev.nodejs_24;
      })
    ];
  };
}
