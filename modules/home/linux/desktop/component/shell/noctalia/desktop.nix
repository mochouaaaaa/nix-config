{
  lib,
  config,
  ...
}:
with lib;
let
  cfgDesktop = config.profiles.desktop;
  cfgNoctalia = config.programs.noctalia;
in
{
  config = mkIf (cfgNoctalia.enable) (mkMerge [
    {
      services.blueman-applet.enable = lib.mkForce false;
      services.network-manager-applet.enable = lib.mkForce false;
    }

    # hyprland
    (mkIf (cfgDesktop.hyprland.enable) {
      programs.vicinae.enable = true;
      programs.noctalia = {
        settings = {
          theme = {
            templates = {
              builtin_ids = [
                "hyprland"
              ];
            };
          };
        };
      };

    })

    (mkIf (cfgDesktop.niri.enable) {

      programs.vicinae.enable = true;
      programs.noctalia = {
        settings = {
          theme = {
            templates = {
              builtin_ids = [
                "niri"
              ];
            };
          };
        };
      };

      wayland.windowManager.niri.settings = {

        binds =
          let
            allow-inhibiting = false;

            noctalia = args: {
              _props.allow-inhibiting = allow-inhibiting;
              spawn = [
                "noctalia-shell"
                "ipc"
                "call"
              ]
              ++ args;
            };
          in
          {
            "Mod+Comma" = noctalia [
              "settings"
              "toggle"
            ];

            "XF86AudioRaiseVolume" = noctalia [
              "volume"
              "increase"
            ];

            "XF86AudioLowerVolume" = noctalia [
              "volume"
              "decrease"
            ];

            "XF86AudioMute" = noctalia [
              "volume"
              "muteOutput"
            ];

            "XF86AudioPlay" = noctalia [
              "media"
              "playPause"
            ];

            "XF86AudioNext" = noctalia [
              "media"
              "next"
            ];

            "XF86AudioPrev" = noctalia [
              "media"
              "previous"
            ];

            "XF86MonBrightnessUp" = noctalia [
              "brightness"
              "increase"
            ];

            "XF86MonBrightnessDown" = noctalia [
              "brightness"
              "decrease"
            ];

            "Mod+Ctrl+q" = noctalia [
              "lockScreen"
              "lock"
            ];
          };
        overview.workspace-shadow.off = { };
        _children = [

          {
            include = {
              _props.optional = true;
              _args = [ "noctalia.kdl" ];
            };
          }

          # Noctalia wallpaper
          {
            layer-rule._children = [
              {
                match._props.namespace = "^noctalia-wallpaper*";
              }
              { place-within-backdrop = true; }
            ];
          }

          # Quickshell overview
          {
            layer-rule._children = [
              {
                match._props.namespace = "^quickshell-overview$";
              }
              { place-within-backdrop = true; }
            ];
          }

          # Noctalia notifications
          {
            layer-rule._children = [
              {
                match._props.namespace = "noctalia-notifications";
              }
              { block-out-from = "screencast"; }
            ];
          }
        ];

      };

    })

  ]);
}
