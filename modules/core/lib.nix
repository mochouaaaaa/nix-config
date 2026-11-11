{ inputs, ... }:

let
  mkMyLib =
    lib:
    import ../../lib {
      inherit lib inputs;
    };
in
{
  # NixOS
  flake.modules.nixos.core = { pkgs, ... }: {
    _module.args.mylib = mkMyLib pkgs.lib;
  };

  # Darwin
  flake.modules.darwin.core = { pkgs, ... }: {
    _module.args.mylib = mkMyLib pkgs.lib;
  };

  # Home Manager
  flake.modules.homeManager.core = { pkgs, ... }: {
    _module.args.mylib = mkMyLib pkgs.lib;
  };
}
