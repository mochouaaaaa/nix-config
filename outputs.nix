inputs@{ flake-parts, import-tree, ... }:
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = import inputs.systems;

  imports = [

    ./modules

    ./overlays

    (import-tree [
      ./hosts
      ./flake-parts
      ./shells
    ])

  ];
}
