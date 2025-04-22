{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
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
  ];

  programs = rec {
    yazi = {
      enable = true;
      # package = inputs.yazi.packages.${pkgs.system}.default;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };
    zsh.initExtra = lib.optionalString (yazi.enable) ''
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
      if [[ -n "$YAZI_ID" ]]; then
          function _yazi_cd() {
              ya pub dds-cd --str "$PWD"
          }
          add-zsh-hook zshexit _yazi_cd
      fi

    '';
  };

  xdg.configFile = {
    "yazi" = {
      force = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi";
    };
  };
}
