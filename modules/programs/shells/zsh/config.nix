{

  flake.modules.generic.zsh = { pkgs, username, ... }: {
    users.users.${username}.description = "${username}. up up up!";
    programs.zsh = {
      enable = true;
      enableCompletion = false;
      enableBashCompletion = false;
    };
    environment.shells = [ pkgs.zsh ];
  };

  flake.modules.nixos.core = { self, ... }: {
    imports = [ self.modules.generic.zsh ];
  };

  flake.modules.darwin.core = { self, ... }: {
    imports = [ self.modules.generic.zsh ];
  };

  flake.modules.homeManager.programs = { pkgs, config, ... }: {

    programs = {
      bash = {
        enable = true;
        package = pkgs.bashInteractive.override {
          inherit (pkgs) readline;
        };
      };
      zsh = {
        enable = true;
        # completionInit = ''
        #   autoload -U compinit && compinit -d /tmp/zcompdump-$(whoami)-$ZSH_VERSION
        # '';
        enableCompletion = true;
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
