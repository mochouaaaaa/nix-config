{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "darwin" = {
      includes = [
        (inputs.flake-aspects.lib.forward {
          each = [ null ];
          fromClass = _: "generic";
          intoClass = _: "homeManager";
          intoPath = _: [ ];
          fromAspect = _: aspects."session-variables";
        })
      ];
      homeManager = { ... }: { };
    };

    "linux" = {
      includes = [
        (inputs.flake-aspects.lib.forward {
          each = [ null ];
          fromClass = _: "generic";
          intoClass = _: "homeManager";
          intoPath = _: [ ];
          fromAspect = _: aspects."session-variables";
        })
      ];

      homeManager =
        { config, ... }:
        let
          d = config.xdg.dataHome;
        in
        {
          home.sessionVariables.WINEPREFIX = d + "/wine";
        };
    };

    "session-variables".generic =
      { config, ... }:
      let
        c = config.xdg.configHome;
        cache = config.xdg.cacheHome;
      in
      {
        home.sessionVariables = {
          LESSHISTFILE = cache + "/less/history";
          LESSKEY = c + "/less/lesskey";
          DELTA_PAGER = "less -R";
        };
      };
  };
}
