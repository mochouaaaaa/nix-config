{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.profiles.services.databases.postgresql;
in
{
  options.profiles.services.databases.postgresql = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable postgresql packages.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        enableJIT = true;

        initialScript = pkgs.writeText "init-sql-script" ''
          ALTER USER "${username}" WITH PASSWORD 'password';
        '';
        authentication = pkgs.lib.mkForce ''
          # TYPE  DATABASE        USER            ADDRESS                 METHOD
          local   all             postgres                                peer
          # 允许本机用户通过 Unix Socket 使用密码登录
          local   all             all                                     scram-sha-256
          # 允许本机通过 127.0.0.1 使用密码登录
          host    all             all             127.0.0.1/32            scram-sha-256
          host    all             all             ::1/128                 scram-sha-256
        '';
        settings = {
          password_encryption = "scram-sha-256";

          log_connections = true;
          log_statement = "all";
          logging_collector = true;
          log_disconnections = true;
          log_destination = lib.mkForce "syslog";
        };
        ensureDatabases = [ "${config.networking.hostName}" ];

        ensureUsers = [
          {
            name = username;
            ensureClauses = {
              superuser = true;
              createrole = true;
              createdb = true;
            };
          }
        ];

      };
    };
  };

}
