{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable) {

    services.blueman-applet.enable = true;
    services.network-manager-applet.enable = true;
    services.cliphist.enable = true;

    systemd.user.services =
      let
        set_config =
          {
            busName,
            exec,
          }:
          {
            Install = {
              WantedBy = [ config.wayland.systemd.target ];
            };
            Unit = {
              After = [
                config.wayland.systemd.target
              ];
              Wants = [
                config.wayland.systemd.target
              ];
            };
            Service = {
              ExecStart = exec;
              BusName = busName;
              Restart = "on-failure";
            };
          };
      in
      {
        # xdg-desktop-portal-gtk = set_config {
        #   busName = "org.freedesktop.impl.portal.desktop.gtk";
        #   exec = "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk";
        # };
        # xdg-desktop-portal-gnome = set_config {
        #   busName = "org.freedesktop.impl.portal.desktop.gnome";
        #   exec = "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome";
        # };
      };
    # // lib.mkIf (cfg.niri.enable) {
    #   xwayland-satellite = set_config {
    #     busName = "org.freedesktop.impl.portal.desktop.niri";
    #     exec = lib.getExe pkgs.xwayland-satellite;
    #   };
    # };

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
