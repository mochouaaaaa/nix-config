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

    programs.noctalia-shell = {
      showScreenCorners = false;
    };

    programs.niri.settings = {
      binds = with config.lib.niri.actions; {
        # "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
        "Mod+Comma".action = spawn "noctalia-shell" "ipc" "call" "settings" "toggle";

        "XF86AudioRaiseVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
        "XF86AudioLowerVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
        "XF86AudioMute".action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput");
        "XF86AudioPlay".action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "playPause");
        "XF86AudioNext".action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "next");
        "XF86AudioPrev".action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "previous");

        # F2
        "XF86MonBrightnessUp".action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
        # F1
        "XF86MonBrightnessDown".action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";

        # "Mod+P".action = spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard";
        "Mod+Ctrl+q".action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock";
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
