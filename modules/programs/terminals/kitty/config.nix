{
  flake.modules.homeManager."programs.kitty" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.profiles.terminal.kitty;

      kitty-icon = pkgs.fetchFromGitHub {
        owner = "DinkDonk";
        repo = "kitty-icon";
        rev = "main";
        hash = "sha256-f+uiesvd0Vdoef6X2kqmbd+4CX2TXdkUGwZdzaKg5bY=";
      };
    in
    {

      options.profiles.terminal = {
        kitty = with lib; {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to enable kitty.";
          };
          extraConfig = mkOption rec {
            type = types.listOf types.str;
            default = [ ];
            description = "Extra configuration lines for kitty.conf.";
            apply = userValue: default ++ userValue;
          };
          icon = mkOption {
            type = types.path;
            default = kitty-icon;
          };
        };
      };

      config = {
        profiles.terminal.kitty.extraConfig = lib.mkBefore [
          "globinclude config/*.conf"
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
            extraConfig = lib.mkOrder 500 (lib.concatStringsSep "\n" cfg.extraConfig);
            mouseBindings = {
              "ctrl+left click" = "ungrabbed mouse_handle_click link";
            };
            enableGitIntegration = true;
            shellIntegration = {
              enableBashIntegration = true;
              enableZshIntegration = true;
              mode = "enabled";
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

    };

}
