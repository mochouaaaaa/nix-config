{ inputs, ... }:
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  # flake-parts defaults to inputs.nixpkgs for every system. The unstable
  # input no longer supports Intel macOS, so select the dedicated 26.05
  # Darwin package set for perSystem outputs on x86_64-darwin.
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs =
        import (if system == "x86_64-darwin" then inputs.nixpkgs-darwin else inputs.nixpkgs)
          {
            inherit system;
            config.allowUnfree = true;
          };
    };
}
