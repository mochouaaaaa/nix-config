{
  pkgs,
  ...
}:
{
  programs.zsh = {
    plugins = [
      {
        name = "zsh-powerlevel10k";
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        src = pkgs.zsh-powerlevel10k;
      }
      {
        name = "zsh-fast-syntax-highlighting";
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        src = pkgs.zsh-fast-syntax-highlighting;
      }
      {
        name = "zsh-fzf-tab";
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "fzf-tab-source";
        file = "fzf-tab-source.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "Freed-Wu";
          repo = "fzf-tab-source";
          rev = "main";
          sha256 = "sha256-0k6x4AhO8ULqanA+1bTNLhMGVz2A3K7LXQ/MgSLuQkc=";
        };
      }
    ];
  };
}
