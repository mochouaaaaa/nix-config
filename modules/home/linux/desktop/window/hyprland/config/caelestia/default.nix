{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;

  caelestia-shell = inputs.caelestia-shell.packages."x86_64-linux".default;
  caelestia-cli = inputs.caelestia-cli.packages."x86_64-linux".default;
in
{
  imports = lib.importModule' ./.;

  options.modules'.desktop.hyprland.caelestia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable caelestia integration";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      caelestia-cli
      caelestia-shell
    ];

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod,Space,global,caelestia:launcher"
          "$mod CTRL, q, global, caelestia:lock"

          "$mod CTRL, S, exec, caelestia screenshot -r -f"
          "$mod CTRL, A, exec, caelestia screenshot --region -f"
          "$mod, P, exec, caelestia clipboard"
        ];
        bindl = [
          ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
          ", XF86MonBrightnessDown, global, caelestia:brightnessDown"

          ", XF86AudioPlay, global, caelestia:mediaToggle"
          ", XF86AudioPause, global, caelestia:mediaToggle"
          ", XF86AudioNext, global, caelestia:mediaNext"
          ", XF86AudioPrev, global, caelestia:mediaPrev"
          ", XF86AudioStop, global, caelestia:mediaStop"
        ];
      };
    };

    home.sessionVariables = {
      CAELESTIA_BD_PATH = "${caelestia-shell}/bin";
    };

    systemd.user.services.caelestia = {
      Unit = {
        Description = "Caelestia Shell Service";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${caelestia-shell}/bin/caelestia-shell";
        Restart = "on-failure";
        RestartSec = "5s";
        TimeoutStopSec = "5s";
        Environment = [
          "QT_QPA_PLATFORM=wayland"
        ];

        Slice = "session.slice";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    modules'.themes.auto = {
      enable = true;
      gtkTheme.enable = true;
    };

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          caelestia scheme set -f latte  -n catppuccin -m light
          switch-theme Light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          caelestia scheme set -f mocha -n catppuccin -m dark
          switch-theme Dark
        '';
      };
    };

  };
}
