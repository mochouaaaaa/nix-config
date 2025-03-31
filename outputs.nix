inputs @ {flake-parts, ...}:
flake-parts.lib.mkFlake {inherit inputs;} (
  {
    config,
    lib,
    self',
    ...
  }: let
    mylib = import ./lib {inherit inputs lib;};
    myvars = import ./vars {inherit lib;};
  in {
    imports = [
      ./modules
      ./hosts
    ];

    flake = {
      templates = import ./templates;
      mylib = mylib;
      myvars = myvars;
    };

    systems = import inputs.systems;
    perSystem = {
      config,
      self',
      inputs',
      pkgs,
      system,
      lib,
      ...
    }: rec {
      config = {
        formatter = pkgs.alejandra;
      };
    };
  }
)
