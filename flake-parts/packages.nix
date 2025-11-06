{
  inputs,
  system,
  lib,
  ...
}:
let

  mkPkgs =
    nixpkgsInput:
    {
      overlays ? [ ],
      custom_config ? { },
      ...
    }:
    import nixpkgsInput {
      inherit system;

      hostPlatform = system;

      config =
        lib.mkForce {
          allowUnfree = true;
          config.allowBroken = true;
          tarball-ttl = 0;
        }
        // custom_config;
      inherit overlays;
    };

  pkgs-unstable = mkPkgs inputs.nixpkgs-unstable { };
  pkgs-os = mkPkgs inputs.nixpkgs-os { };

  nvfetcherSources = import ../_sources/generated.nix {
    inherit (pkgs-os)
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
    mkPkgs
    pkgs-unstable
    pkgs-os
    nvfetcherSources
    ;
}
