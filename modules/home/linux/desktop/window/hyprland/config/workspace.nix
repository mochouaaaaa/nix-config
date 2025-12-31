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
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"

          "$mod CTRL, 2, togglespecialworkspace, tg"

          # Move active window and follow to workspace mainMod + SHIFT [1-5]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"

          # Special workspace
          "$mod SHIFT, U, movetoworkspace, special"
          "$mod, U, togglespecialworkspace"

          # Workspaces related
          "$mod, tab, workspace, m+1"
          "$mod SHIFT, tab, workspace, m-1"
        ];
        windowrule = [
          #"workspace name:tencent, match:class ^([Tt]hunderbird)$"
          #"workspace name:browser, match:class ^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
          #"workspace name:browser, match:class ^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$"
          #"workspace name:browser, match:class ^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
          #"workspace name:obs, match:class ^(com.obsproject.Studio)$"
          #"workspace name:steam, match:class ^([Ss]team)$"
          #"workspace name:steam, match:class ^([Ll]utris)$"
          #"workspace name:tencent, match:class ^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"
          #"workspace name:tencent, match:class ^([Ff]erdium)$"
          #"workspace name:tencent, match:class ^([Ww]hatsapp-for-linux)$"
          "workspace special:tg, match:class io.github.kukuruzka165.materialgram"
          "workspace special:tg, match:class org.telegram.desktop"

          "workspace special:todo, match:class Todoist"
        ];
        workspace = [
          "w[tv1]s[false], gapsout:4"
          "f[1]s[false], gapsout:4"
        ];
      };
    };
  };
}
