{ config, lib, ... }:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri = {
      settings.window-rules = [
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
            { app-id = "^(pavucontrol|pavucontrol-qt|com.saivert.pwvucontrol)$"; }
            { app-id = "io.github.fsobolev.Cavalier"; }
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
          opacity = 0.85;
          excludes = [
            # {
            #   app-id = "^fcitx5$";
            # }
          ];
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
          matches = [
            { app-id = "^(org.wezfurlong.wezterm)$"; }
          ];
          default-column-width = { };
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
          # matches = [
          #   {
          #     app-id = "^(org.keepassxc.KeePassXC|org.gnome.World.Secrets|Bitwarden).*$";
          #   }
          # ];
          # block-out-from = "screencast";
        }
      ];

    };
  };
}
