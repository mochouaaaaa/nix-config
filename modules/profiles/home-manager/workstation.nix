_: {
  # Platform-neutral workstation role. Platform-specific integration remains
  # in homeManager.linux and homeManager.darwin.
  flake.aspects = { aspects, ... }: {
    workstation = {
      includes = [
        aspects.cli
        aspects.development-languages
        aspects.desktop-vscode
        aspects.desktop-kitty
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = _: { };
    };
  };
}
