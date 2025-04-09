{
  pkgs,
  config,
  ...
}:
{
  home.shell = {
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    zinit
    zoxide
    dust
    procs
    less
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {

      ".." = "cd ..";
      "~" = "cd ~";
      "--" = "cd -";

      du = "dust";
      ps = "procs";
    };
    initExtra = ''

      if [[ $- != *i* ]]; then
          return
      fi

      source ${config.dotfiles}/zsh/init.zsh

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      hash -d desktop="$HOME/Desktop"
      hash -d downloads="$HOME/Downloads"
      hash -d documents="$HOME/Documents"
      hash -d videos="$HOME/Videos"
      hash -d music="$HOME/Music"
      hash -d pictures="$HOME/Pictures"
      hash -d movies="$HOME/Movies"
      hash -d trash="$HOME/.Trash"

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
    enableCompletion = false;
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
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/zsh";
    };
  };
}
