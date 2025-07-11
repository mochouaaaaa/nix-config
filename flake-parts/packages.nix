{
  inputs,
  system,
  lib,
  ...
}:
let

  mkPkgs =
    nixpkgsInput:
    import nixpkgsInput {
      inherit system;

      hostPlatform = system;

      config = lib.mkForce {
        allowUnfree = true;
        config.allowBroken = true;
        tarball-ttl = 0;
      };

    };

  pkgs-unstable = mkPkgs inputs.nixpkgs-unstable;
  pkgs-stable = mkPkgs inputs.nixpkgs-stable;

  nvfetcherSources = import ../_sources/generated.nix {
    inherit (pkgs-stable)
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
    pkgs-unstable
    pkgs-stable
    nvfetcherSources
    ;
}
