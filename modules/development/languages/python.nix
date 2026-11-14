{

  flake.modules.homeManager.development = { self, ... }: {
    imports = [
      self.modules.homeManager."development.python"
    ];
  };

  # GUI development applications are enabled only by Linux desktop hosts.
  flake.modules.homeManager."development.gui" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      home.packages = lib.optional config.programs.ty.enable pkgs.pycharm;
    };

  flake.modules.homeManager."development.python" = { lib, pkgs, ... }: {

    home.packages = [
      pkgs.playwright-driver.browsers
    ];

    programs.zsh.initContent = lib.mkAfter ''
      export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}";
      export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD="1";
    '';

    programs = {
      ty = {
        enable = true;
        # package = inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.ty;
        # package = pkgs.ty.overrideAttrs (oldAttrs: rec {
        #   version = "0.0.31";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "astral-sh";
        #     repo = "ty";
        #     tag = version;
        #     fetchSubmodules = true;
        #     hash = "sha256-TJGEI22hp+YZCxIvZgNc8BF2Dd+z/TzpnRW2pO1f3X0=";
        #   };
        #   cargoDeps = pkgs.rustPlatform.importCargoLock {
        #     lockFile = src + "/ruff/Cargo.lock";
        #     allowBuiltinFetchGit = true;
        #   };
        #   cargoHash = null;
        # });
      };
      ruff = {
        enable = true;
        settings = {
          line-length = 120;
          per-file-ignores = {
            "__init__.py" = [ "F401" ];
          };
          indent-width = 4;
          lint = {
            select = [
              "E4"
              "E7"
              "E9"
              "F"
              "C90"
            ];
            ignore = [
              "E402"
              "F403"
              "F405"
            ];
            fixable = [ "ALL" ];
            unfixable = [ ];
            dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$";
          };
          format = {
            exclude = [ "*.pyi" ];
            quote-style = "double";
            indent-style = "space";
            skip-magic-trailing-comma = false;
            line-ending = "auto";
            docstring-code-format = false;
            docstring-code-line-length = "dynamic";
          };
        };
      };
      uv = {
        enable = true;
        settings = {
          pip.index-url = "https://mirrors.ustc.edu.cn/pypi/web/simple";
        };
      };
    };

    # Keep machine-wide Ruff defaults in Ruff's own Home Manager module.
    # Project-specific type-checker and pytest settings belong in each project's
    # pyproject.toml or pyrightconfig.json, not in Ruff's configuration file.

  };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.uv.enable
          [
            ".local/share/uv"
          ];
    };

}
