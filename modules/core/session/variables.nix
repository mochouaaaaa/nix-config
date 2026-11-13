{ self, ... }: {
  flake.modules.homeManager.darwin.imports = [
    self.modules.homeManager."core.session-variables"
  ];

  flake.modules.homeManager.linux = { config, ... }:
    let d = config.xdg.dataHome;
    in {
      imports = [ self.modules.homeManager."core.session-variables" ];
      home.sessionVariables.WINEPREFIX = d + "/wine";
    };

  flake.modules.homeManager."core.session-variables" = { config, ... }:
    let
      c = config.xdg.configHome;
      cache = config.xdg.cacheHome;
    in {
      home.sessionVariables = {
        LESSHISTFILE = cache + "/less/history";
        LESSKEY = c + "/less/lesskey";
        BROWSER = "firefox";
        DELTA_PAGER = "less -R";
      };
    };
}
