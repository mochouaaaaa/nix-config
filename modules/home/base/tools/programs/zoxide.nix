{
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh.initExtra = ''
      alias j="z"
    '';
  };
}
