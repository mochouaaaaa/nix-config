{
  inputs,
  system,
  ...
}:
let

  mkPkgs =
    nixpkgsInput:
    import nixpkgsInput {
      inherit system;
      config.allowUnfree = true;
      config.allowBroken = true;
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
  # Make our overlay available to the devShell
  # "Flake parts does not yet come with an endorsed module that initializes the pkgs argument.""
  # So we must do this manually; https://flake.parts/overlays#consuming-an-overlay
  inherit
    nixpkgs
    pkgs-unstable
    pkgs-stable
    nvfetcherSources
    ;
}
