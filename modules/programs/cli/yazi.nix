{
  flake.modules.homeManager.programs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      yaziRuntimeDeps =
        with pkgs;
        [
          # db
          duckdb
          # pdf
          # zathura
          # markdown
          glow
          # image
          chafa
          ueberzugpp
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          wl-clipboard
          evince
        ];
    in
    {

      programs = {
        yazi = {
          enable = true;
          extraPackages = yaziRuntimeDeps;
          plugins = with pkgs.yaziPlugins; {
            inherit git;
            inherit chmod;
            inherit ouch;
            inherit full-border;
            inherit duckdb;
            inherit piper;
            inherit vcs-files;
            inherit jump-to-char;
            inherit smart-enter;
            inherit smart-filter;
            inherit smart-paste;
          };
          theme = {
            git = {
              unknown_sign = " ";
              modified_sign = "M";
              deleted_sign = "D";
              clean_sign = "✔";
              modified = {
                fg = "blue";
              };
              deleted = {
                fg = "red";
                bold = true;
              };
            };
          };
        };

        zsh.initContent = ''
          if [[ -n "$YAZI_ID" ]]; then
              function _yazi_cd() {
                  ya emit cd "$PWD"
              }
              add-zsh-hook zshexit _yazi_cd
          fi

          # Kitty: launch Yazi silently in the current shell
          function kitty-yazi-widget() {
              if [[ -n "$BUFFER" ]]; then
                  zle -M "Clear the command line before launching Yazi"
                  return 1
              fi

              zle -I
              command yazi
              zle reset-prompt
          }

          zle -N kitty-yazi-widget
          bindkey '\e[57399;5u' kitty-yazi-widget
        '';
      };
      profiles.terminal.kitty = {
        extraConfig = [
          "map cmd+r send_text all \\x1b[57399;5u"
          "map --when-focus-on var:IS_NVIM cmd+r"
          "map --when-focus-on var:IS_TMUX cmd+r"
        ];
      };

      xdg.configFile = config.profiles.dotfileLink "yazi";

    };
}
