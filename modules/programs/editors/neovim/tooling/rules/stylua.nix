{
  flake.modules.homeManager."cli.neovim.tooling.rules.stylua" = { pkgs, ... }:
    let
      settings = {
        indent_width = 4;
        call_parentheses = "NoSingleTable";
        collapse_simple_statement = "FunctionOnly";

        sort_requires = {
          enabled = true;
        };
      };
    in
    {
      xdg.configFile."rules/stylua.toml".source =
        (pkgs.formats.toml { }).generate "stylua.toml" settings;
    };
}
