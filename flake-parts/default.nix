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

    ./imports.nix

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
      customPkgs = import ./packages.nix { inherit inputs system; };
      isNixos = builtins.pathExists "/etc/nixos";
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

        # Extra arguments passed to the module system for nix-darwin, NixOS, and home-manager
        extraModuleArgs =
          {
            inherit isNixos;
            isLinux = pkgs.stdenv.isLinux && !isNixos;
          }
          // {
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
              nixpkgs
              pkgs-unstable
              pkgs-stable
              nvfetcherSources
              ;
          };

      };
    };
}
