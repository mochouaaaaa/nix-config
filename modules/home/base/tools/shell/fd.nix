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
    zsh.shellAliases = {
      find = "fd";
    };
  };
}
