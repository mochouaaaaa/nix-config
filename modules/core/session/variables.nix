{

  flake.modules.homeManager.darwin = { self, ... }: {
    imports = [
      self.modules.generic.session-variables
    ];
  };

  flake.modules.homeManager.linux =
    { self, config, ... }:
    let
      d = config.xdg.dataHome;
    in
    {
      imports = [ self.modules.generic.session-variables ];
      home.sessionVariables.WINEPREFIX = d + "/wine";
    };

  flake.modules.generic.session-variables =
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

}
