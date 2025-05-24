{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.modules.desktop.niri;
in
{

  config = lib.mkIf cfg.enable {

    # Ref: https://github.com/hallettj/home.nix/blob/main/home-manager/features/niri/default.nix
    services.blueman-applet.enable = true;
    systemd.user.services.blueman-applet.Install = lib.mkForce {
      # Replace "graphical-session.target" so that this only starts when Niri starts.
      WantedBy = [ "tray.target" ];
    };

    services.network-manager-applet.enable = true;
    systemd.user.services.network-manager-applet.Install = lib.mkForce {
      # Replace "graphical-session.target" so that this only starts when Niri starts.
      WantedBy = [ "tray.target" ];
    };

    systemd.user = {
      services = {
        xwayland-satellite = {
          Install = {
            WantedBy = [
              "niri.service"
            ];
          };
          Unit = {
            After = [
              "graphical-session.target"
            ];
            Wants = [
              "graphical-session.target"
            ];
          };
          Service = {
            ExecStart = lib.getExe pkgs.xwayland-satellite;
            Restart = "on-failure";
          };
        };
      };
      targets.tray = {
        Unit = {
          After = [ "niri.service" ];
        };
        Install = {
          WantedBy = [ "niri.service" ];
        };
      };
    };

    # Use Gnome Keyring as SSH agent
    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

  };
}
