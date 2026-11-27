{ inputs, ... }:

let
  mkMyLib =
    lib:
    import ../../../lib {
      inherit lib inputs;
    };
in
{
  # NixOS
  flake.aspects."core"."nixos" = { pkgs, ... }: {
    _module.args.mylib = mkMyLib pkgs.lib;
  };

  # Darwin
  flake.aspects."core"."darwin" = { pkgs, ... }: {
    _module.args.mylib = mkMyLib pkgs.lib;
  };

  # Home Manager
  flake.aspects."core"."homeManager" = { pkgs, ... }: {
    _module.args.mylib = mkMyLib pkgs.lib;
  };
}
