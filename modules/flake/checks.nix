{
  perSystem =
    { config, ... }:
    {
      checks = {
        # treefmt-nix registers its formatting check automatically.
        # Keep the additional project-specific build check here.
        devshell = config.devShells.default;
      };
    };
}

# nix flake check
