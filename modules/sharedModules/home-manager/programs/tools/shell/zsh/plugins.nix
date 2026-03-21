{ pkgs, config, ... }:
{
  programs.zsh = {
    initContent = ''
      source ${config.programs.zsh.dotDir}/.p10k.zsh 
    '';
    plugins = [
      {
        name = "zsh-powerlevel10k";
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        src = pkgs.zsh-powerlevel10k.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "romkatv";
            repo = "powerlevel10k";
            rev = "main";
            hash = "sha256-J8qKLkKYd62LuUY2y6Hy+AaokKVDSTucCNQwVQeAaxo=";
          };
        });
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
          sha256 = "sha256-ar025RTlDFWEnE9Ql8WBz4tiBmz1B2tsZiRI2/mVCDI=";
        };
      }
    ];
  };
}
