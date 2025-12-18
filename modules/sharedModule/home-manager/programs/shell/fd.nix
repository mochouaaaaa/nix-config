{
  programs = {
    fd = {
      enable = true;
      ignores = [
        ".git/"
        "*.bak"
        ".backup/"
      ];
    };
  };

  # home.shellAliases = {
  #   find = "fd";
  # };
}
