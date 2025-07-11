{ inputs, ... }:

(
  final: prev:

  let
    composed = inputs.nixpkgs.lib.composeManyExtensions [
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      inputs.niri.overlays.niri
      inputs.nuenv.overlays.default
    ];
  in
  composed final prev
  // {
    waybar_git = inputs.waybar.packages.${final.pkgs.stdenv.hostPlatform.system}.waybar;
  }
)
