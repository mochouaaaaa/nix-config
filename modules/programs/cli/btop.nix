{
  flake.aspects = { cli.provides.btop.homeManager = {
    programs.btop.enable = true;
  };
};
}
