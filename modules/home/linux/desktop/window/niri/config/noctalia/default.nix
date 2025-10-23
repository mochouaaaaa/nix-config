{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.noctalia;
in
{

  config = lib.mkIf cfg.enable {

    programs.noctalia-shell.settings = {
      general = {
        showScreenCorners = false;
      };
    };

    programs.niri.settings = {
      binds = with config.lib.niri.actions; {
        # "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
        "Mod+Comma".action = spawn "noctalia-shell" "ipc" "call" "settings" "toggle";

        "XF86AudioRaiseVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
        "XF86AudioLowerVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
        "XF86AudioMute".action = spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput";

        "XF86MonBrightnessUp".action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
        "XF86MonBrightnessDown".action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";

        # "Mod+P".action = spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard";
        "Mod+Ctrl+q".action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "toggle";
      };
      layer-rules = [
        {
          matches = [
            {
              namespace = "^quickshell-overview$";
            }
          ];
          place-within-backdrop = true;
        }
      ];
    };
  };
}
