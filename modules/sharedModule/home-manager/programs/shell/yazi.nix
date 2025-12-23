{
  config,
  pkgs,
  lib,
  ...
}:
let
  yaziRuntimeDeps =
    with pkgs;
    [
      # db
      duckdb
      # pdf
      zathura
      evince
      # markdown
      glow
      # image
      chafa
      ueberzugpp
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      wl-clipboard
    ];
in
{
  programs =
    let
      warpper_shell = ''
        _yazi(){
            if [ -n "$YAZI_LEVEL" ]; then
                exit
            fi

            local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                cd -- "$cwd"
            fi
            rm -f -- "$tmp"
        }
      '';
    in
    rec {
      yazi = {
        enable = true;
        package = (pkgs.yazi.override { extraPackages = yaziRuntimeDeps; });
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
      };
      zsh.initContent = lib.optionalString (yazi.enable) warpper_shell + ''
        if [[ -n "$YAZI_ID" ]]; then
            function _yazi_cd() {
                ya emit cd "$PWD"
            }
            add-zsh-hook zshexit _yazi_cd
        fi
      '';
      bash.initExtra = warpper_shell;
    };

  xdg.configFile = config.modules'.dotfileLink "yazi";

}
