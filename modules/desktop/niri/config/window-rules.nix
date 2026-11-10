{
  flake.modules.homeManager."desktop.niri" = {

    wayland.windowManager.niri.settings = {
      _children = [
        {
          window-rule._children = [
            {
              match._props = {
                is-floating = true;
              };
            }
            {
              shadow.on = { };
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^(org.gnome.Nautilus|nm-connection-editor)$";
              };
            }
            {
              match._props = {
                app-id = "pot";
                title = "Translate";
              };
            }
            {
              match._props = {
                app-id = "firefox";
                title = "Picture-in-Picture";
              };
            }
            {
              match._props = {
                app-id = "zen";
                title = "Picture-in-Picture";
              };
            }
            {
              open-floating = true;
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^mpv$";
              };
            }
            {
              variable-refresh-rate = true;
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^(chromium-browser|firefox|zen|zen-beta)$";
              };
            }
            {
              match._props = {
                app-id = "io.github.kukuruzka165.materialgram";
              };
            }
            {
              match._props = {
                app-id = "org.telegram.desktop";
              };
            }
            {
              opacity = 0.85;
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^(org.wezfurlong.wezterm)$";
              };
            }
            {
              default-column-width = { };
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^org.gnome.Nautilus$";
              };
            }
            {
              min-width = 1145;
              min-height = 672;
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "steam";
                title = ''^notificationtoasts_\d+_desktop$'';
              };
            }
            {
              default-floating-position._props = {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              };
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^org.keepassxc.KeePassXC$";
              };
            }
            {
              match._props = {
                app-id = "^org.gnome.World.Secrets$";
              };
            }
            {
              match._props = {
                app-id = "Bitwarden";
              };
            }
            {
              block-out-from = "screencast";
            }
          ];
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^org.keepassxc.KeePassXC$";
              };
            }
            {
              match._props = {
                app-id = "^org.gnome.World.Secrets$";
              };
            }
            {
              match._props = {
                app-id = "Bitwarden";
              };
            }
            {
              block-out-from = "screen-capture";
            }
          ];
        }
      ];

      # layer-rules = [
      #   {
      #     matches = [
      #       { namespace = ""; }
      #     ];
      #     place-within-backdrop = true;
      #   }
      # ];
    };

  };
}
