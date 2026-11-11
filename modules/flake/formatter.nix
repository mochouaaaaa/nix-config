{ inputs, ... }: {

  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = { config, ... }: {

    devShell = {
      inputsFrom = [ config.pre-commit.devShell ];
    };

    treefmt = {
      projectRootFile = "flake.nix";

      programs.nixfmt.enable = true;
      programs.deadnix.enable = true;
      programs.statix.enable = true;

      settings.global.excludes = [
        ".direnv/**"
        "result"
        "result/**"
        ".git/**"

        "secrets/**"
      ];
    };

    # Git Commit Hook
    pre-commit.settings.hooks.treefmt = {
      enable = true;
      name = "treefmt";
      entry = "${config.treefmt.build.wrapper}/bin/treefmt";
      language = "system";
      pass_filenames = true;
      files = "\\.nix$";
    };

  };
}

# nix fmt
