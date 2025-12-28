{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.packages.terminal.kitty;
in
{

  config = lib.mkIf (cfg.enable && config.programs.desktop.enable) {
    modules'.packages.terminal.kitty.extraConfig = lib.mkBefore [
      "include init.conf"
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
        '';
      };
      bash.initExtra = lib.mkOrder 2400 ''
        if [[ -n "$KITTY_WINDOW_ID" ]]; then
             kitty +complete setup bash | source /dev/stdin
             alias ssh="kitty +kitten ssh"
        fi
      '';
      kitty = {
        enable = true;
        package = pkgs.kitty;
        font = {
          name = "Monaco Nerd Font";
          size = 16;
        };
        # themeFile = "Catppuccin-Mocha";
        extraConfig = lib.mkOrder 900 (lib.concatStringsSep "\n" (cfg.extraConfig));
        enableGitIntegration = true;
        shellIntegration = {
          enableZshIntegration = true;
          enableBashIntegration = true;
          # enableFishIntegration = true;
        };
      };
    };

    xdg.configFile = {
      "kitty/kitty.conf" = {
        force = true;
        enable = true;
      };
    }
    // config.modules'.dotfileLink "kitty";
  };
}
