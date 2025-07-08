{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = lib.importModule' ./.;

  home.packages = with pkgs; [
    less
  ];

  programs = {
    bash = {
      enable = true;
    };
    zsh = rec {
      enable = true;
      enableCompletion = false;
      syntaxHighlighting = {
        enable = true;
        package = pkgs.zsh-syntax-highlighting;
      };
      initContent = ''
        source ${config.dotfiles}/zsh/init.zsh

        source $HOME/${dotDir}/.p10k.zsh 
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
  };

  xdg.configFile = {
    "zsh" = {
      force = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/zsh";
    };
  };
}
