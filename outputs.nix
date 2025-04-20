inputs@{ flake-parts, ... }:
flake-parts.lib.mkFlake { inherit inputs; } (
  {
    config,
    lib,
    self',
    ...
  }:
  let
    systems = import inputs.systems;

    mylib = import ./lib { inherit inputs lib; };
    myvars = import ./vars { inherit lib; };

    pkgs = import inputs.nixpkgs {
      inherit (config) systems;
    };
    nvfetcherSources = import ./_sources/generated.nix {
      inherit (pkgs)
        fetchurl
        fetchgit
        fetchFromGitHub
        dockerTools
        ;
    };
  in
  {
    inherit systems;

    imports = [
      ./modules
      ./hosts
    ];

    flake = {
      templates = import ./templates;
      mylib = mylib;
      myvars = myvars;
      nvfetcherSources = nvfetcherSources;
    };

    perSystem =
      {
        config,
        self',
        inputs',
        pkgs,
        system,
        lib,
        ...
      }:
      rec {
        config = {
          formatter = pkgs.alejandra;
        };
      };
  }
)
