{ inputs, ... }:
{
  flake.overlays = {
    darwin = import ./darwin.nix { inherit inputs; };
    nixos = import ./nixos.nix { inherit inputs; };
    home-manager = import ./home-manager.nix { inherit inputs; };
  };
}
