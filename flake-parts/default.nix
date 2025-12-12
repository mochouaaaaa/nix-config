{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [
    ./nixos.nix
    ./darwin.nix
    ./home-manager.nix

    ./_lib.nix

    ./dev-shells
  ];

  perSystem =
    {
      pkgs,
      lib,
      system,
      self',
      inputs',
      ...
    }:
    let
      customPkgs = import ./packages.nix { inherit inputs system lib; };
      myvars = import ../config.nix;
    in
    {

      _module.args = {

        # nix the package manager configuration
        nix = import ./nix-settings.nix {
          inherit
            lib
            inputs
            inputs'
            pkgs
            ;
        };

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

        extraPackages = {
          inherit (customPkgs)
            mkPkgs
            pkgs-unstable
            pkgs-os
            ;
        };

        # Extra arguments passed to the module system for nix-darwin, NixOS, and home-manager
        extraModuleArgs = {
          inherit
            self'
            inputs'
            inputs
            system
            myvars
            ;
        }
        // {
          inherit (customPkgs)
            nvfetcherSources
            ;
        };

      };

    };
}
