{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.noctalia-shell;
in
{

  config = lib.mkIf (cfg.enable) {

    programs.noctalia-shell.settings = lib.mkDefaultRecursive {
      appLauncher = {
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
      };
      bar = {
        backgroundOpacity = 0.88;
        outerCorners = true;
      };
      dock = {
        enabled = false;
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
      };
      general = {
        animationSpeed = 0.78;
        avatarImage = "${config.home.homeDirectory}/.face";
      };
      hooks = {
        darkModeChange =
          let
            hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
              mode=$1

              is_random="${lib.boolToString cfg.settings.wallpaper.automationEnabled}"

              if [ "$mode" = "true" ]; then
                # [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/Dynamic-Wallpapers/Dark/Summer-Scene-Dark.png DP-1
                [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/Anime-Girl2.png DP-1
              else
                [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/Dynamic-Wallpapers/Light/Summer-Scene-Light.png DP-1
              fi
            '';
          in
          "${lib.getExe hook_theme} $1";
      };
      notifications = {
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
      };
      osd = {
        backgroundOpacity = cfg.settings.ui.panelBackgroundOpacity;
      };
      ui = {
        panelBackgroundOpacity = 0.78;
        fontDefault = "${config.profiles.fonts.default}";
        fontFixed = "${config.profiles.fonts.default}";
      };
      wallpaper = {
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
      };
    };

  };

}
