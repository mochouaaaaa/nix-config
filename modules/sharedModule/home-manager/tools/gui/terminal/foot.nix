{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.packages.terminal.foot;
in
{

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && !config.programs.wsl.enable) {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Monaco Nerd Font Mono:size=16";
          dpi-aware = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };

}
