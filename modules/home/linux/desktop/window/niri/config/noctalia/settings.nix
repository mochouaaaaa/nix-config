{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.noctalia;
  cfgNiri = config.modules'.desktop.niri;
in
{

  config = lib.mkIf (cfg.enable && cfgNiri.enable) {

    programs.niri.settings = {
      binds =
        let
          allow-inhibiting = false;
        in
        with config.lib.niri.actions;
        {
          # "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
          "Mod+Comma" = {
            inherit allow-inhibiting;
            action = spawn "noctalia-shell" "ipc" "call" "settings" "toggle";
          };

          "XF86AudioRaiseVolume" = {
            inherit allow-inhibiting;
            action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
          };
          "XF86AudioLowerVolume" = {
            inherit allow-inhibiting;
            action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
          };
          "XF86AudioMute" = {
            inherit allow-inhibiting;
            action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput");
          };
          "XF86AudioPlay" = {
            inherit allow-inhibiting;
            action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "playPause");
          };
          "XF86AudioNext" = {
            inherit allow-inhibiting;
            action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "next");
          };
          "XF86AudioPrev" = {
            inherit allow-inhibiting;
            action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "previous");
          };

          # F2
          "XF86MonBrightnessUp" = {
            inherit allow-inhibiting;
            action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
          };
          # F1
          "XF86MonBrightnessDown" = {
            inherit allow-inhibiting;
            action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";
          };

          # "Mod+P".action = spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard";
          "Mod+Ctrl+q" = {
            inherit allow-inhibiting;
            action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock";
          };
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
