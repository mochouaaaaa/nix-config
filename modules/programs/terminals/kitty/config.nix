{

  flake.modules.homeManager."programs.kitty" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      fontFamily = "Monaco Nerd Font";
    in
    {

      config = {

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
              name = fontFamily;
              size = 16;
            };
            extraConfig = lib.mkOrder 100 ''
              globinclude config/*.conf

              # font_features ${config.profiles.fonts.default} -liga -clig -calt
              # symbol_map U+003C,U+003D,U+003E,U+0021,U+002D,U+0026,U+007C,U+002B Fira Code

            '';
            mouseBindings = {
              "ctrl+left click" = "ungrabbed mouse_handle_click link";
            };
            enableGitIntegration = true;
            shellIntegration = {
              enableBashIntegration = true;
              enableZshIntegration = true;
            };
          };
        };

        xdg.configFile = {
          "kitty/kitty.conf" = {
            enable = true;
            force = true;
          };
        }
        // config.profiles.dotfileLink "kitty";

      };

    };

}
