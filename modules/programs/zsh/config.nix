{
  flake.modules.homeManager.programs = { pkgs, config, ... }: {

    programs = {
      bash = {
        enable = true;
        package = pkgs.bashInteractive.override {
          readline = pkgs.readline;
        };
      };
      zsh = {
        enable = true;
        # completionInit = ''
        #   autoload -U compinit && compinit -d /tmp/zcompdump-$(whoami)-$ZSH_VERSION
        # '';
        enableCompletion = true;
        fastSyntaxHighlighting = {
          enable = true;
        };
        dotDir = "${config.xdg.configHome}/zsh";
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

  };
}
