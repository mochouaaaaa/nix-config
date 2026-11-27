{
  flake.aspects = { cli.provides.fd.homeManager = {
    programs.fd = {
      enable = true;
      ignores = [
        ".git/"
        "*.bak"
        ".backup/"
      ];
    };
  };
};
}
