{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.envs.python;
in
{
  config = lib.mkIf cfg.enable {

    programs = {
      ty = {
        enable = true;
      };
      ruff = {
        enable = true;
        settings = {
          line-length = 120;
          per-file-ignores = {
            "__init__.py" = [ "F401" ];
          };
          lint = {
            ignore = [
              "E402"
              "F403"
              "F405"
            ];
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

    xdg.configFile."ruff/pyproject.toml".source =
      let
        settingsFormat = pkgs.formats.toml { };

        settings = {
          tool.basedpyright = {
            pythonPlatform = "all";
            typeCheckingMode = "standard";
            useLibraryCodeForTypes = true;

            disableLanguageServices = false;

            reportAssignmentType = "none";
            reportAttributeAccessIssue = "none";
            reportMissingImports = true;
            reportMissingTypeStubs = false;
          };

          tool.uv = {
            package-installation = "isolated";
            cache-builds = true;
          };

          tool.uv.venv = {
            in-poject = true;
          };

          tool.ruff = {
            # Same as Black
            line-length = 120;
            indent-width = 4;
          };

          tool.ruff.lint = {
            # Enable Pyflakes (`F`) and a subset of the pycodestyle (`E`)  codes by default.
            # Unlike Flake8, Ruff doesn't enable pycodestyle warnings (`W`) or
            # McCabe complexity (`C901`) by default.

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

            # Allow fix for all enabled rules (when `--fix`) is provided.
            fixable = [ "ALL" ];
            unfixable = [ ];

            # Allow unused variables when underscore-prefixed.
            dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$";

          };

          tool.ruff.format = {
            exclude = [ "*.pyi" ];
            # Like Black, use double quotes for strings.
            quote-style = "double";
            # Like Black, indent with spaces, rather than tabs.
            indent-style = "space";
            # Like Black, respect magic trailing commas.
            skip-magic-trailing-comma = false;
            # Like Black, automatically detect the appropriate line ending.
            line-ending = "auto";
            # Enable auto-formatting of code examples in docstrings. Markdown,
            # reStructuredText code/literal blocks and doctests are all supported.
            #
            # This is currently disabled by default, but it is planned for this
            # to be opt-out in the future.
            docstring-code-format = false;
            # Set the line length limit used when formatting code snippets in
            # docstrings.
            #
            # This only has an effect when the `docstring-code-format` setting is
            # enabled.
            docstring-code-line-length = "dynamic";
          };

          tool.pyright = {
            venvPath = ".";
            venv = ".venv";
          };

          tool.pytest.ini_options = {
            pythonpath = [ "." ];
            DJANGO_SETTINGS_MODULE = "django_ninjia.settings";
          };

        };
      in
      settingsFormat.generate "pyproject.toml" settings;

  };

}
