{

  flake.modules.darwin."services.mysql" = {
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

  flake.modules.nixos."services.mysql" =
    {
      pkgs,

      username,
      ...
    }:
    {
      # networking.firewall.allowedTCPPorts = [ 3306 ];

      # networking.firewall.interfaces."enp3s0".allowedTCPPorts = [ 3306 ];

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
