{ pkgs, ... }:
let
  settingsFormat = pkgs.formats.json { };
in
{
  xdg.configFile."rules/.prettierrc.json".source =
    let
      settings = {
        printWidth = 120;
        useTabs = true;
        semi = true;
        quoteProps = "consistent";
        arrowParens = "avoid";
      };
    in
    settingsFormat.generate ".prettierrc.json" settings;
}
