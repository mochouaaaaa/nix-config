inputs@{ flake-parts, ... }:
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = import inputs.systems;

  imports = [
    ./flake-parts

    ./hosts
    ./modules

    ./overlays
  ];
}
