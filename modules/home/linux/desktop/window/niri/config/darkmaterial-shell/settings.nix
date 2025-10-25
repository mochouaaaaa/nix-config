{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.programs.dankMaterialShell;
in
{

  imports = [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      binds = with config.lib.niri.actions; {
        "Mod+Ctrl+q".action = spawn "dms" "ipc" "call" "lock" "lock";
        # "Mod+Space".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
        # "Mod+P" = {
        #   hotkey-overlay.title = "Clipboard Manager";
        #   action = spawn "dms" "ipc" "call" "clipboard" "toggle";
        # };
        "Mod+M" = {
          hotkey-overlay.title = "Task Manager";
          action.spawn = [
            "dms"
            "ipc"
            "call"
            "processlist"
            "toggle"
          ];
        };
        "Mod+Comma" = {
          hotkey-overlay.title = "Settings";
          action.spawn = [
            "dms"
            "ipc"
            "call"
            "settings"
            "toggle"
          ];
        };

        "XF86AudioMute".action = spawn "dms" "ipc" "call" "audio" "mute";
        "XF86AudioMicMute".action = spawn "dms" "ipc" "call" "audio" "micmute";
        "XF86AudioRaiseVolume".action = spawn "dms" "ipc" "call" "audio" "increment" "3";
        "XF86AudioLowerVolume".action = spawn "dms" "ipc" "call" "audio" "decrement" "3";
        "XF86MonBrightnessUp".action = spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
        "XF86MonBrightnessDown".action = spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
      };
    };

  };

}
