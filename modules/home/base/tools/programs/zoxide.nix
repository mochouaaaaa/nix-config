{
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh.initContent = ''
      alias j="z"
    '';
  };
}
