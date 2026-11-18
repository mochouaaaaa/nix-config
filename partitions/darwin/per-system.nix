{ inputs, ... }:
{
  systems = [
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs-darwin {
        inherit system;
        config.allowUnfree = true;
      };
    };

  imports = [ ../per-system.nix ];
}
