{ inputs, ... }:
{
  perSystem =
    { inputs', system, ... }:
    {
      _module.args = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit
            system
            ; # refer the `system` parameter form outer scope recursively
          # To use chrome, we need to allow the installation of non-free software
          config.allowUnfree = true;
        };
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          # To use chrome, we need to allow the installation of non-free software
          config.allowUnfree = true;
        };
      };
    };
}
