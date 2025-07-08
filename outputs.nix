inputs@{ flake-parts, ... }:
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = import inputs.systems;

  imports = [
    ./flake-parts

    ./hosts
    ./modules

    ./overlays
  ];

  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    {

      packages = import ./packages { inherit pkgs; };
    };
}
