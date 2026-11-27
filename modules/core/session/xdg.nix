{
  flake.aspects."core".homeManager = { config, ... }: {
    xdg = {
      enable = true;
      localBinInPath = true;
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";
    };
  };
}
