{ self, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
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
              allowBroken = true;
              tarball-ttl = 0;
            }
            // custom_config;
          inherit overlays;
        };

      pkgs-unstable = mkPkgs inputs.nixpkgs { };
      pkgs-os = mkPkgs inputs.nixpkgs-os { };

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

        # nixpkgs configuration (not the flake input)
        nixpkgs = {
          config = lib.mkForce {
            allowBroken = true;
            allowUnfree = true;
            tarball-ttl = 0;

            # Experimental options, disable if you don't know what you are doing!
            contentAddressedByDefault = false;
          };

          hostPlatform = system;
        };

        # Extra arguments passed to the module system for nix-darwin, NixOS, and home-manager
        extraModuleArgs =
          let
            myvars = import ../config.nix;
            import-tree = inputs.import-tree;
          in
          {
            inherit
              self
              inputs
              system

              # custom
              myvars
              nvfetcherSources

              # nixpkgs
              mkPkgs
              pkgs-unstable
              pkgs-os

              import-tree

              ;
          };

      };

    };
}
