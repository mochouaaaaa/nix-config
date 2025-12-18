{ pkgs, ... }:
let
  settingsFormat = pkgs.formats.toml { };
in
{
  xdg.configFile."rules/stylua.toml".source =
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
    settingsFormat.generate "stylua.toml" settings;
}
