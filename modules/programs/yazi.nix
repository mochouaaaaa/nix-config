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

      programs = rec {
        yazi = {
          enable = true;
          extraPackages = yaziRuntimeDeps;
          enableZshIntegration = false;
          enableBashIntegration = false;
          enableFishIntegration = false;
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
        zsh.initContent = lib.optionalString yazi.enable ''
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
