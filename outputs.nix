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
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit (config) systems;
      # refer the `system` parameter form outer scope recursively
      # To use chrome, we need to allow the installation of non-free software
      config.allowUnfree = true;
    };
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit (config) systems;
      # To use chrome, we need to allow the installation of non-free software
      config.allowUnfree = true;
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
    _module.args = {
      inherit pkgs-unstable pkgs-stable;
    };

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
  }
)
