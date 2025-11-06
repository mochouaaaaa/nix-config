{ config, lib, ... }:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri = {
      settings = {
        layer-rules = [
          {
            matches = [
              {
                namespace = "noctalia-notifications";
              }
            ];
            block-out-from = "screencast";
          }
        ];

        window-rules =
          let
            hide_matches = [
              {
                app-id = "^org\.keepassxc\.KeePassXC$";
              }
              {
                app-id = "^org\.gnome\.World\.Secrets$";
              }
              {
                app-id = "Bitwarden";
              }
            ];
          in
          [
            {
              geometry-corner-radius =
                let
                  radius = 12.0;
                in
                {
                  bottom-left = radius;
                  bottom-right = radius;
                  top-left = radius;
                  top-right = radius;
                };
              clip-to-geometry = true;
              draw-border-with-background = false;
            }
            {
              matches = [
                { is-floating = true; }
              ];
              shadow.enable = true;
            }
            {
              matches = [
                {
                  app-id = "^(org.gnome.Nautilus|nm-connection-editor)$";
                }
                {
                  app-id = "pot";
                  title = "Translate";
                }
                {
                  app-id = "firefox";
                  title = "Picture-in-Picture";
                }
                {
                  app-id = "zen";
                  title = "Picture-in-Picture";
                }
                {
                  app-id = "imv";
                  title = "^imv - .*\\.png \\[scale to fit\\]$";
                }
                { app-id = "^(pavucontrol|pavucontrol-qt|com.saivert.pwvucontrol)$"; }
                { app-id = "io.github.fsobolev.Cavalier"; }
                { app-id = "org.gnome.Loupe"; }
                { app-id = "dialog"; }
                { app-id = "task_dialog"; }
                { app-id = "popup"; }
                { app-id = "file-roller"; }
                { app-id = "org.gnome.FileRoller"; }
                { app-id = "nm-connection-editor"; }
                { app-id = "blueman-manager"; }
                { app-id = "xdg-desktop-portal-gtk"; }
                { app-id = "org.kde.polkit-kde-authentication-agent-1"; }
                { app-id = "pinentry"; }
                {
                  app-id = "io.github.kukuruzka165.materialgram";
                  title = "媒体查看器";
                }
                { title = "Progress"; }
                { title = "File Operations"; }
                { title = "Copying"; }
                { title = "Moving"; }
                { title = "Properties"; }
                { title = "Downloads"; }
                { title = "file progress"; }
                { title = "Confirm"; }
                { title = "Authentication Required"; }
                { title = "Notice"; }
                { title = "Warning"; }
                { title = "Error"; }
              ];
              open-floating = true;
            }
            {
              matches = [
                {
                  app-id = "^mpv$";
                }
              ];
              variable-refresh-rate = true;
            }
            {
              opacity = 0.85;
              matches = [
                { app-id = "^(chromium-browser|firefox|zen|zen-beta)$"; }
                { app-id = "io.github.kukuruzka165.materialgram"; }
              ];
            }
            {
              matches = [
                { app-id = "^(org.wezfurlong.wezterm)$"; }
              ];
              default-column-width = { };
            }
            {
              matches = [
                {
                  app-id = "^(org.gnome.Nautilus)$";
                }
              ];
              min-width = 1145;
              min-height = 672;
            }
            {
              matches = [
                {
                  app-id = "steam";
                  title = "^notificationtoasts_\d+_desktop$";
                }
              ];
              default-floating-position = {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              };
            }
            {
              # obs
              matches = hide_matches;
              block-out-from = "screencast";
            }
            {
              matches = hide_matches;
              block-out-from = "screen-capture";
            }
          ];

      };

    };
  };
}
