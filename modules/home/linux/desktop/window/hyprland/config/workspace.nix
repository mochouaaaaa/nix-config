{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          # Switch workspaces with mainMod + [1-5]
          "$mod, 1, workspace, name:code"
          "$mod, 2, workspace, name:browser"
          "$mod, 3, workspace, name:docs"
          "$mod, 4, workspace, name:tencent"
          "$mod, 5, workspace, name:steam"
          "$mod, 6, workspace, name:obs"
          "$mod CTRL, 1, togglespecialworkspace, music"
          "$mod CTRL, 2, togglespecialworkspace, tg"
          "$mod CTRL, 3, togglespecialworkspace, wechat"

          # Move active window and follow to workspace mainMod + SHIFT [1-5]
          "$mod SHIFT, 1, movetoworkspace, name:code"
          "$mod SHIFT, 2, movetoworkspace, name:browser"
          "$mod SHIFT, 3, movetoworkspace, name:docs"
          "$mod SHIFT, 4, movetoworkspace, name:tencent"
          "$mod SHIFT, 5, movetoworkspace, name:steam"
          "$mod SHIFT, 6, movetoworkspace, name:obs"

          # Special workspace
          "$mod SHIFT, U, movetoworkspace, special"
          "$mod, U, togglespecialworkspace"

          # Workspaces related
          "$mod, tab, workspace, m+1"
          "$mod SHIFT, tab, workspace, m-1"
        ];
        windowrule = [
          "workspace name:tencent, class:^([Tt]hunderbird)$"
          "workspace name:browser, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
          "workspace name:browser, class:^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$"
          "workspace name:browser, class:^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
          "workspace name:obs, class:^(com.obsproject.Studio)$"
          "workspace name:steam, class:^([Ss]team)$"
          "workspace name:steam, class:^([Ll]utris)$"
          "workspace name:tencent, class:^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"
          "workspace name:tencent, class:^([Ff]erdium)$"
          "workspace name:tencent, class:^([Ww]hatsapp-for-linux)$"
          "workspace special:music, class:^(Spotify)$"
          "workspace special:tg, class:io.github.kukuruzka165.materialgram"
        ];
        exec-once = [
          "hyprctl dispatch workspace name:code"
        ];
      };
    };
  };
}
