{ inputs, ... }: {

  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = { lib, config, ... }: {

    devShell = {
      inputsFrom = [ config.pre-commit.devShell ];
    };

    treefmt = {
      projectRootFile = "flake.nix";

      programs.nixfmt.enable = true;
      programs.deadnix.enable = true;
      programs.statix.enable = true;

      settings.global = {
        "no-cache" = true;
        excludes = [
          ".git/**"
          ".direnv/**"
          "result"
          "result/**"
          "flake.lock"

          "secrets/**"
        ];
      };
    };

    # Git Commit Hook
    pre-commit.settings.hooks.treefmt = {
      enable = true;
      name = "treefmt";
      entry = "${lib.getExe config.treefmt.build.wrapper} --no-cache";
      language = "system";
      pass_filenames = true;
      files = "\\.nix$";
    };

  };
}

# nix fmt
