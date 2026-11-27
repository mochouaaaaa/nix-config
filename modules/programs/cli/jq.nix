{
  flake.aspects = { cli.provides.jq.homeManager = {
    programs.jq.enable = true;
  };
};
}
