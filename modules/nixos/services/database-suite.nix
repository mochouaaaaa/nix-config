{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
let
  cfg = config.modules.packages.database-suite;

  user = "${myvars.username}";
in
{
  options.modules.packages.database-suite = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable databases packages.";
    };
  };

  config = lib.mkIf cfg.enable {

    services = {
      redis = {
        servers = {
          "" = {
            enable = true;
            bind = null;
            # unixSocket = "/var/run/redis.sock";
            openFirewall = true;
          };
        };
      };

      mysql = {
        enable = true;
        package = pkgs.mariadb;
        # user = user;
        # group = user;
        ensureUsers = [
          {
            name = user;
            ensurePermissions = {
              "*.*" = "ALL PRIVILEGES";
            };
          }
        ];
        ensureDatabases = [
          user
        ];
        replication = {
          role = "master";
          masterUser = user;
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
