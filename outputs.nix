inputs@{ flake-parts, import-tree, ... }:
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = import inputs.systems;

  imports = [
    (import-tree [
      ./flake-parts
      ./shells
    ])
  ]
  ++ [

    ./hosts
    ./modules

    ./overlays
  ];
}
