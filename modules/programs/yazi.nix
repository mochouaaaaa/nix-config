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
        ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
          wl-clipboard
          evince
        ];
    in
    {

      programs = rec {
        yazi = {
          enable = true;
          extraPackages = yaziRuntimeDeps;
          enableZshIntegration = false;
          enableBashIntegration = false;
          enableFishIntegration = false;
          plugins = with pkgs.yaziPlugins; {
            git = git;
            chmod = chmod;
            ouch = ouch;
            full-border = full-border;
            duckdb = duckdb;
            piper = piper;
            vcs-files = vcs-files;
            jump-to-char = jump-to-char;
            smart-enter = smart-enter;
            smart-filter = smart-filter;
            smart-paste = smart-paste;
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
        zsh.initContent = lib.optionalString (yazi.enable) ''
          if [[ -n "$YAZI_ID" ]]; then
              function _yazi_cd() {
                  ya emit cd "$PWD"
              }
              add-zsh-hook zshexit _yazi_cd
          fi
        '';
      };

      xdg.configFile = config.profiles.dotfileLink "yazi";

    };
}
