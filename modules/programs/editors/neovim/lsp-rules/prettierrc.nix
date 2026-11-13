{
  flake.modules.homeManager.programs =
    { pkgs, ... }:
    {
      xdg.configFile."rules/.prettierrc.json".source =
        let
          settings = {
            printWidth = 120;
            useTabs = true;
            semi = true;
            singleQuote = true;
            trailingComma = "all";
            quoteProps = "consistent";
            arrowParens = "avoid";
            tabWidth = 2;
            endOfLine = "lf";
          };
        in
        (pkgs.formats.json { }).generate ".prettierrc.json" settings;
    };
}
