{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.packages.terminal.foot;
in
{

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.profiles.desktop.enable) {
    programs.foot = {
      enable = false;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "${config.profiles.fonts.default}:size=16";
          dpi-aware = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };

}
