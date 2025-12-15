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
        plugins = {
          git = pkgs.yaziPlugins.git;
          chmod = pkgs.yaziPlugins.chmod;
          ouch = pkgs.yaziPlugins.ouch;
          full-border = pkgs.yaziPlugins.full-border;
          duckdb = pkgs.yaziPlugins.duckdb;
          piper = pkgs.yaziPlugins.piper;
          vcs-files = pkgs.yaziPlugins.vcs-files;
          jump-to-char = pkgs.yaziPlugins.jump-to-char;
          smart-enter = pkgs.yaziPlugins.smart-enter;
          smart-filter = pkgs.yaziPlugins.smart-filter;
        };
      };
      zsh.initContent = lib.optionalString (yazi.enable) warpper_shell + ''
        if [[ -n "$YAZI_ID" ]]; then
            function _yazi_cd() {
                ya pub dds-cd --str "$PWD"
            }
            add-zsh-hook zshexit _yazi_cd
        fi
      '';
      bash.initExtra = warpper_shell;
    };

  xdg.configFile = config.modules'.dotfileLink "yazi";

}
