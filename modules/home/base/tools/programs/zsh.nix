{
  pkgs,
  config,
  ...
}:
{
  home.shell = {
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    defaultKeymap = "vicmd";
    autosuggestion = {
      enable = true;
    };
    dotDir = ".config/zsh";
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
