{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.modules'.desktop.niri;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.xwayland-satellite
    ];

    programs.niri.settings = {
      spawn-at-startup = [
        # { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
        # { command = [ "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk" ]; }
        # { command = [ "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome" ]; }
      ];
    };

    # Ref: https://github.com/hallettj/home.nix/blob/main/home-manager/features/niri/default.nix
    services.blueman-applet.enable = true;
    services.network-manager-applet.enable = true;

    systemd.user = {
      services =
        let
          get_config = _start: {
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
              ExecStart = _start;
              Restart = "on-failure";
            };
          };
        in
        {
          xwayland-satellite = get_config (lib.getExe pkgs.xwayland-satellite);
          xdg-desktop-portal-gtk = get_config "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk";
          xdg-desktop-portal-gnome = get_config "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome";
          blueman-applet.Install = lib.mkForce {
            # Replace "graphical-session.target" so that this only starts when Niri starts.
            WantedBy = [ "tray.target" ];
          };
          network-manager-applet.Install = lib.mkForce {
            # Replace "graphical-session.target" so that this only starts when Niri starts.
            WantedBy = [ "tray.target" ];
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
