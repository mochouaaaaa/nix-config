{
  lib,
  pkgs,
  config,
  pkgs-unstable,
  ...
}:
let
  cfg = config.modules.packages.kitty;

  kitty-icon = pkgs.fetchFromGitHub {
    owner = "DinkDonk";
    repo = "kitty-icon";
    rev = "main";
    hash = "sha256-f+uiesvd0Vdoef6X2kqmbd+4CX2TXdkUGwZdzaKg5bY=";
  };
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
    icon = lib.mkOption {
      type = lib.types.path;
      default = kitty-icon;
    };
  };

  config = lib.mkIf cfg.enable {
    modules.packages.kitty.extraConfig = [
      "include init.conf"
      # "shell ${config.programs.zsh.package}/bin/zsh --login --interactive"
    ];

    programs = {
      zsh = {
        initContent = lib.mkOrder 2400 ''
          if [[ -n "$KITTY_WINDOW_ID" ]]; then
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

          if test -n "$KITTY_INSTALLATION_DIR"; then
              export KITTY_SHELL_INTEGRATION="enabled"
              autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
              kitty-integration
              unfunction kitty-integration
          fi
        '';
      };
      bash.initExtra = lib.mkOrder 2400 ''
        if [[ -n "$KITTY_WINDOW_ID" ]]; then
             kitty +complete setup bash | source /dev/stdin
             alias ssh="kitty +kitten ssh"
        fi

        if test -n "$KITTY_INSTALLATION_DIR"; then
            export KITTY_SHELL_INTEGRATION="enabled"
            source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
        fi
      '';
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
