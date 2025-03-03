{
  lib,
  myvars,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    extraConfig = lib.mkIf myvars.desktop.kde ''
      hide_window_decorations yes
      background_opacity 1.0
    '';
  };

  xdg.configFile."kitty/kitty.conf".enable = false;
}
