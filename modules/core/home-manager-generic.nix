{
  flake.modules.homeManager."platform.non-linux" = {
    targets.genericLinux.enable = true;
  };
}
