{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.profiles.services.databases.mysql;
in
{
  options.profiles.services.databases.mysql = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable mysql packages.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mysql = {
        enable = true;
        package = pkgs.mariadb;
        # user = user;
        # group = user;
        ensureUsers = [
          {
            name = username;
            ensurePermissions = {
              "*.*" = "ALL PRIVILEGES";
            };
          }
        ];
        ensureDatabases = [
          username
        ];
        replication = {
          role = "master";
          masterUser = username;
          masterPassword = "P@ssw0rd";
          slaveHost = "%";
        };
        settings = {
          mysqld = {
            bind-address = "0.0.0.0";
            port = 3306;
            key_buffer_size = "6G";
            table_cache = 1600;
            log-error = "/var/log/mysql_err.log";
            plugin-load-add = [
              "server_audit"
              "ed25519=auth_ed25519"
            ];
          };
          mysqldump = {
            quick = true;
            max_allowed_packet = "16M";
          };
        };
      };
    };

  };

}
