{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.programs.dankMaterialShell;
  cfgNiri = config.modules'.desktop.niri;
in
{

  imports = [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  config = lib.mkIf (cfg.enable && cfgNiri.enable) {

    programs.dankMaterialShell = {
      default.settings = lib.mkForce {
        dankBarGothCornersEnabled = false;
      };
    };

    programs.niri.settings = {
      binds =
        let
          allow-inhibiting = false;
        in
        with config.lib.niri.actions;
        {
          "Mod+Ctrl+q" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "lock" "lock";
          };
          # "Mod+Space".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
          # "Mod+P" = {
          #   hotkey-overlay.title = "Clipboard Manager";
          #   action = spawn "dms" "ipc" "call" "clipboard" "toggle";
          # };
          "Mod+M" = {
            inherit allow-inhibiting;
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
            inherit allow-inhibiting;
            hotkey-overlay.title = "Settings";
            action.spawn = [
              "dms"
              "ipc"
              "call"
              "settings"
              "toggle"
            ];
          };

          "XF86AudioMute" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "audio" "mute";
          };
          "XF86AudioMicMute" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "audio" "micmute";
          };
          "XF86AudioRaiseVolume" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "audio" "increment" "3";
          };
          "XF86AudioLowerVolume" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "audio" "decrement" "3";
          };
          "XF86MonBrightnessUp" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
          };
          "XF86MonBrightnessDown" = {
            inherit allow-inhibiting;
            action = spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
          };
        };
    };

  };

}
