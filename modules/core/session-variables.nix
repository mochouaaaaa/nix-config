{ self, ... }: {

  flake.modules.homeManager.darwin = {
    imports = [
      self.modules.homeManager."core.session-variables"
    ];
  };

  flake.modules.homeManager.linux =
    { config, ... }:
    let
      d = config.xdg.dataHome;
    in
    {
      imports = [
        self.modules.homeManager."core.session-variables"
      ];

      home.sessionVariables = {
        WINEPREFIX = d + "/wine";
      };
    };

  flake.modules.homeManager."core.session-variables" =
    {

      config,
      ...
    }:
    let
      c = config.xdg.configHome;
      cache = config.xdg.cacheHome;
    in
    {

      # environment variables that always set at login
      home.sessionVariables = {
        # clean up ~
        LESSHISTFILE = cache + "/less/history";
        LESSKEY = c + "/less/lesskey";

        # set default applications
        BROWSER = "firefox";

        # enable scrolling in git diff
        DELTA_PAGER = "less -R";
      };
    };

}
