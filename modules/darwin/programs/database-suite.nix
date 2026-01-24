{ config, lib, ... }:
let
  cfg = config.profiles.services.database-suite;
in
{
  options.profiles.services.database-suite = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable databases packages.";
    };
  };

  config = lib.mkIf cfg.enable {

    services = {
      redis = {
        enable = true;
        bind = "0.0.0.0";
        # extraConfig = '''';
        unixSocket = "/var/run/redis.sock";
      };
    };

    # mariadb
    # SET PASSWORD FOR 'root'@'localhost' = PASSWORD('P@ssw0rd');
    homebrew.brews = [
      {
        name = "mariadb";
        link = true;
        start_service = true;
        restart_service = true;
        conflicts_with = [ "mariadb" ];
      }
    ];

  };
}
