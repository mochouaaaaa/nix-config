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
        startup =
          let
            hook_startup = pkgs.writeShellScriptBin "hook_startup" ''
              noctalia-shell ipc call colorScheme setGenerationMethod muted
              sleep 0.1
              noctalia-shell ipc call colorScheme setGenerationMethod fruit-salad
              noctalia-shell ipc call idleInhibitor enable
            '';
          in
          "${lib.getExe hook_startup}";

        screenLock =
          let
            hook_lock = pkgs.writeShellScriptBin "hook_lock" ''
              noctalia-shell ipc call idleInhibitor disable
            '';
          in
          "${lib.getExe hook_lock}";
        screenUnlock =
          let
            hook_unlock = pkgs.writeShellScriptBin "hook_unlock" ''
              noctalia-shell ipc call idleInhibitor enable
            '';
          in
          "${lib.getExe hook_unlock}";

        darkModeChange =
          let
            hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
              mode=$1

              is_random="${lib.boolToString cfg.settings.wallpaper.automationEnabled}"

              if [ "$mode" = "true" ]; then
                # [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/Dynamic-Wallpapers/Dark/Summer-Scene-Dark.png DP-1
                [ "$is_random" = "false" ] && noctalia-shell ipc call wallpaper set ${config.home.homeDirectory}/Pictures/Wallpapers/zhizi.png DP-1
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
