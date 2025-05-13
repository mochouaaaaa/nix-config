inputs@{ flake-parts, ... }:
flake-parts.lib.mkFlake { inherit inputs; } (
  let
    systems = import inputs.systems;
  in
  {
    inherit systems;

    debug = true;

    imports = [
      ./flake-parts
      ./modules
      ./hosts
    ];

    flake = {
      myvars = import ./vars;
    };
  }
)
