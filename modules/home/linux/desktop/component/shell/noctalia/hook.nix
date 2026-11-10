{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        hooks = {
          started =
            let
              hook_startup = pkgs.writeShellScriptBin "hook_startup" ''
                noctalia msg caffeine-enable
                hyprctl reload
              '';
            in
            "${lib.getExe hook_startup}";

          session_locked = [
            "playerctl pause"
            "noctalia msg bar-hide"
            "noctalia msg caffeine-disable"
          ];

          session_unlocked = [
            "noctalia msg bar-show"
            "noctalia msg dpms-on"
            "noctalia msg caffeine-enable"
          ];

          theme_mode_changed =
            let
              hook_theme = pkgs.writeShellScriptBin "hook_theme" ''
                mode=$NOCTALIA_THEME_MODE

                is_random="${lib.boolToString cfg.settings.wallpaper.automation.enabled}"

                if [ "$mode" = "dark" ]; then
                  [ "$is_random" = "false" ] && noctalia msg wallpaper-set DP-1 ${config.home.homeDirectory}/Pictures/Wallpapers/zhizi.png
                else
                  [ "$is_random" = "false" ] && noctalia msg wallpaper-set DP-1 ${config.home.homeDirectory}/Pictures/Wallpapers/Dynamic-Wallpapers/Light/Summer-Scene-Light.png
                fi
              '';
            in
            "${lib.getExe hook_theme}";
        };
      };
    };
  };
}
