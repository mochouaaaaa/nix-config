{ inputs, config, ... }:
let

  systems = config.systems;

  mkPkgs =
    nixpkgsInput:
    import nixpkgsInput {
      inherit systems;
      config.allowUnfree = true;
    };

  pkgs = mkPkgs inputs.nixpkgs;

  pkgs-unstable = mkPkgs inputs.nixpkgs-unstable;
  pkgs-stable = mkPkgs inputs.nixpkgs-stable;

  nvfetcherSources = import ../_sources/generated.nix {
    inherit (pkgs)
      fetchurl
      fetchgit
      fetchFromGitHub
      dockerTools
      ;
  };

in
{
  _module.args = {
    inherit
      pkgs
      pkgs-unstable
      pkgs-stable
      nvfetcherSources
      ;
  };
}
