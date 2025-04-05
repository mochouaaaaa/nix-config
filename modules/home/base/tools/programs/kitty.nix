{
  lib,
  config,
  isDarwin,
  ...
}:
let
  cfgDesktop = if isDarwin then null else config.modules.desktop;
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Monaco Nerd Font Mono";
      size = 16;
    };
    themeFile = "Catppuccin-Mocha";
    extraConfig = lib.concatStringsSep "\n" (
      [
        "include init.conf"
      ]
      ++ lib.optionals (cfgDesktop != null && cfgDesktop.kde.enable) [
        "hide_window_decorations yes"
        "background_opacity 1.0"
      ]
    );
    shellIntegration = {
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };

  xdg.configFile = {
    "kitty" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/kitty";
    };
  };
}
