{
  pkgs,
  config,
  ...
}:
{
  home.shell = {
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [ zinit ];

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # source $HOME/.zsh/plugins/zsh-powerlevel10k/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      if [[ $- != *i* ]]; then
          return
      fi

      source ${config.dotfiles}/zsh/init.zsh

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
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
        name = "zsh-autosuggestions";
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        src = pkgs.zsh-autosuggestions;
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
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
      package = pkgs.zsh-syntax-highlighting;
    };
    autosuggestion = {
      enable = true;
    };
    history = {
      path = "$HOME/.zsh_history";
      size = 1000;
      save = 1000;
      append = true;
      saveNoDups = true;
      ignoreSpace = true;
      ignoreAllDups = true;
      findNoDups = true;
      extended = true; # timestamp
      expireDuplicatesFirst = true;
      ignorePatterns = [
        "rm *"
        "pkill *"
      ];
    };
  };

  xdg.configFile = {
    "zsh" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/zsh";
    };
  };
}
