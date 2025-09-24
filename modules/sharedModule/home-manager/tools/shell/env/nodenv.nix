{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.envs.nodenv;

in
{

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yarn
      pnpm
      fnm
    ];

    programs.zsh.initContent = lib.mkOrder 2150 ''
      alias nodenv="fnm"
      export FNM_DIR="$HOME/.config/env/fnm"
      eval "$(fnm env --shell zsh --use-on-cd --version-file-strategy=recursive)"
    '';
  };
}
