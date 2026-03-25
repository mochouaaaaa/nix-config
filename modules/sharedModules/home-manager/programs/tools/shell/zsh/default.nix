{
  pkgs,
  config,
  ...
}:
{

  programs = {
    bash = {
      enable = true;
      package = pkgs.bashInteractive.override {
        readline = pkgs.readline;
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        package = pkgs.zsh-syntax-highlighting;
      };
      dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion = {
        enable = true;
      };
      history = {
        path = "$HOME/.zsh_history";
        size = 10000;
        save = 10000;
        append = true;
        saveNoDups = true;
        ignoreSpace = true;
        ignoreAllDups = true;
        findNoDups = true;
        extended = true; # timestamp
        expireDuplicatesFirst = true;
        ignorePatterns = [
          "rm *"
          "rm -rf *"
          "rm -rf /.*"
          "pkill *"
        ];
      };
    };
  };
}
