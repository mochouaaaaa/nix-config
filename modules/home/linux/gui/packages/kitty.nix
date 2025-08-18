{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.terminal.kitty;
in
{
  config = lib.mkIf cfg.enable {

    modules'.packages.terminal.kitty = {
      extraConfig = lib.mkAfter [
        "adjust_line_height 100%"
        "adjust_column_width 100%"
        "font_features Monaco Nerd Font Mono -liga -clig -calt"
      ];
    };

    xdg.configFile = {
      "kitty/kitty.app.png".source = "${cfg.icon}/kitty-dark.png";
    };

    xdg.mimeApps.defaultApplications =
      let
        terminal = [ "kitty.desktop" ];
      in
      {
        "x-scheme-handler/ssh" = terminal;
        "x-scheme-handler/telnet" = terminal;
        "x-scheme-handler/x-man-page" = terminal;
        "TerminalEmulator" = terminal;
      };
  };
}
