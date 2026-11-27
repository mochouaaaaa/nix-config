{
  flake.aspects."programs"."homeManager" = {
    programs.fd = {
      enable = true;
      ignores = [
        ".git/"
        "*.bak"
        ".backup/"
      ];
    };
  };
}
