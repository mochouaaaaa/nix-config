{
  lib,
  pkgs,
  config,
  pkgs-unstable,
  ...
}:
let
  cfg = config.modules.packages.kitty;
in
{
  options.modules.packages.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable kitty.";
    };
    extraConfig = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra configuration lines for kitty.conf.";
    };
  };

  config = lib.mkIf cfg.enable {

    modules.packages.kitty.extraConfig = [
      "include init.conf"
      # "shell ${config.programs.zsh.package}/bin/zsh --login --interactive"
    ];

    programs = {
      zsh = {
        initExtra = lib.mkOrder 2400 ''
          if [[ "$TERM_PROGRAM" == "kitty" ]]; then
             kitty +complete setup zsh | source /dev/stdin
             alias ssh="kitty +kitten ssh"

             ctrl_l() {
                builtin print -rn -- $'\r\e[0J\e[H\e[22J' >"$TTY"
                builtin zle .reset-prompt
                builtin zle -R
            }
            zle -N ctrl_l
            bindkey '^l' ctrl_l
          fi
        '';
      };
      kitty = {
        enable = true;
        package = pkgs-unstable.kitty;
        font = {
          name = "Monaco Nerd Font Mono";
          size = 16;
        };
        themeFile = "Catppuccin-Mocha";
        extraConfig = lib.mkOrder 900 (lib.concatStringsSep "\n" (cfg.extraConfig));
        shellIntegration = {
          enableZshIntegration = true;
          enableBashIntegration = true;
        };
      };
      git = {
        extraConfig = {
          diff = {
            tool = "kitty";
            guitool = "kitty.gui";
          };
          difftool = {
            prompt = false;
            trustExitCode = true;
          };
          difftool."kitty" = {
            cmd = "kitty +kitten diff $LOCAL $REMOTE";
          };
          difftool."kitty.gui" = {
            cmd = "kitty kitty +kitten diff $LOCAL $REMOTE";
          };
        };
      };
    };

    xdg.configFile = config.dotfileLink "kitty";
  };
}
