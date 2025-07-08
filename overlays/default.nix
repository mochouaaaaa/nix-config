{ inputs, pkgs, ... }:
{
  flake.overlays = {
    darwin = import ./darwin.nix { inherit inputs pkgs; };
    nixos = import ./nixos.nix { inherit inputs pkgs; };
    home-manager = import ./home-manager.nix { inherit inputs pkgs; };
  };
}
