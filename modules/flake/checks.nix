{
  perSystem =
    { config, ... }:
    {
      checks = {
        # Verify formatting and the enabled Nix static-analysis tools.
        formatting = config.treefmt.build.check config.treefmt.projectRoot;

        # Ensure the default development environment can be built.
        devshell = config.devShells.default;
      };
    };
}

# nix flake check
