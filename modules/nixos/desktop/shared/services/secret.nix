{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf (!cfg.kde.enable && cfg.enable) {

    services = {
      speechd.enable = cfg.gnome.enable;
      gnome = {
        gnome-keyring.enable = lib.mkForce true;
        gcr-ssh-agent.enable = lib.mkForce false;
        evolution-data-server.enable = true;
      };
    };

    # Use pass to manage key status
    profiles.persistent.hmDirectories = [
      {
        directory = ".local/share/keyrings";
        mode = "0755";
      }
    ];

  };

}
