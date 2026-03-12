{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.profiles.packages.terminal.kitty;
in
{

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {
    profiles.packages.terminal.kitty.extraConfig = lib.mkBefore [
      "include init.conf"
      "\n"
      # "font_features ${config.profiles.fonts.default} -liga -clig -calt"
      # "symbol_map U+003C,U+003D,U+003E,U+0021,U+002D,U+0026,U+007C,U+002B Fira Code"
      "\n"
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
          name = "${config.profiles.fonts.default}";
          size = 16;
        };
        extraConfig = lib.mkOrder 900 (lib.concatStringsSep "\n" (cfg.extraConfig));
        enableGitIntegration = true;
        shellIntegration = {
          enableZshIntegration = config.programs.zsh.enable;
          enableBashIntegration = config.programs.bash.enable;
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
    // config.profiles.dotfileLink "kitty";
  };
}
