{ inputs, config, ... }:
let

  systems = config.systems;

  mkPkgs =
    nixpkgsInput:
    import nixpkgsInput {
      inherit systems;
      config.allowUnfree = true;
    };

  nixpkgs = mkPkgs inputs.nixpkgs;

  pkgs-unstable = mkPkgs inputs.nixpkgs-unstable;
  pkgs-stable = mkPkgs inputs.nixpkgs-stable;

  nvfetcherSources = import ../_sources/generated.nix {
    inherit (nixpkgs)
      fetchurl
      fetchgit
      fetchFromGitHub
      dockerTools
      ;
  };

in
{
  inherit
    nixpkgs
    pkgs-unstable
    pkgs-stable
    nvfetcherSources
    ;
}
