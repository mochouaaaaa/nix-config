{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  imports = [ inputs.DankMaterialShell.homeModules.dankMaterialShell ];

  config = lib.mkIf cfg.enable {

    programs.dankMaterialShell = {
      enable = true;
      enableSpawn = true;
    };

    programs.niri.settings.binds = with config.lib.niri.actions; {
      "Mod+Ctrl+q".action = spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "lock" "lock";
      "Mod+Space".action = spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "spotlight" "toggle";
      "Mod+P" = {
        hotkey-overlay.title = "Clipboard Manager";
        action = spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "clipboard" "toggle";
      };
      "Mod+M" = {
        hotkey-overlay.title = "Task Manager";
        action.spawn = [
          "qs"
          "-c"
          "DankMaterialShell"
          "ipc"
          "call"
          "processlist"
          "toggle"
        ];
      };
      "Mod+Comma" = {
        hotkey-overlay.title = "Settings";
        action.spawn = [
          "qs"
          "-c"
          "DankMaterialShell"
          "ipc"
          "call"
          "settings"
          "toggle"
        ];
      };

      "XF86AudioMute".action = spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "audio" "mute";
      "XF86AudioMicMute".action = spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "audio" "micmute";
      "XF86AudioRaiseVolume".action =
        spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "audio" "increment"
          "3";
      "XF86AudioLowerVolume".action =
        spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "audio" "decrement"
          "3";
      "XF86MonBrightnessUp".action =
        spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "brightness" "increment" "5"
          "";
      "XF86MonBrightnessDown".action =
        spawn "qs" "-c" "DankMaterialShell" "ipc" "call" "brightness" "decrement" "5"
          "";
    };

    # auto dark/light theme
    modules'.themes.auto = {
      enable = true;
      gtkTheme = {
        enable = true;
      };
    };

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          switch-theme Light
          qs -c DankMaterialShell ipc call theme light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          qs -c DankMaterialShell ipc call theme dark
          switch-theme Dark
        '';
      };
    };

  };
}
