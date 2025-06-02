{
  self,
  pkgs,
  config,
  ...
}:
{
  imports = self.importModule' ./.;

  home.packages = with pkgs; [
    less
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    syntaxHighlighting = {
      enable = true;
      package = pkgs.zsh-syntax-highlighting;
    };
    initContent = ''
      source ${config.dotfiles}/zsh/init.zsh

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    dotDir = ".config/env/zsh";
    autosuggestion = {
      enable = true;
    };
    history = {
      path = "$HOME/.zsh_history";
      size = 5000;
      save = 5000;
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
