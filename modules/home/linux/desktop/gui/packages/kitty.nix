{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.terminal.kitty;
  desktopCfg = config.profiles.desktop;
in
{
  config = lib.mkIf cfg.enable {

    profiles.packages.terminal.kitty = {
      extraConfig = [
        "adjust_line_height 100%"
        "adjust_column_width 100%"
        "font_features ${config.profiles.fonts.default} -liga -clig -calt"
        "mouse_map        ctrl+left click ungrabbed mouse_handle_click link"
      ]
      ++ lib.optionals desktopCfg.gnome.enable [ "background_opacity 1" ]
      ++ lib.optionals desktopCfg.kde.enable [ "# hide_window_decorations yes" ];
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
