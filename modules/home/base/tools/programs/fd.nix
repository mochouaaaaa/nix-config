{
  programs = {
    fd = {
      enable = true;
      ignores = [
        ".git/"
        "*.bak"
      ];
    };
    zsh.shellAliases = {
      find = "fd";
    };
  };
}
