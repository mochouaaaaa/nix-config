{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.languages.envs.rust;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.rustup
    ];

    programs.zsh.envExtra = ''
      export CARGO_HOME="${config.xdg.dataHome}/cargo"
      export RUSTUP_HOME="${config.xdg.dataHome}/rustup"
    '';

    programs = {
      cargo = {
        enable = false;
      };
    };

  };
}
