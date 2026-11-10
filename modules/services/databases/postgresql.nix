{
  flake.modules.nixos."services.postgresql" =
    {
      pkgs,

      username,
      ...
    }:
    {

      services.postgresql = {
        enable = true;
        enableJIT = true;
        enableTCPIP = true;

        # 密码不要硬编码；用 agenix 或首次部署后手动设置
        initialScript = pkgs.writeText "init-sql-script" ''
          ALTER USER "${username}" WITH PASSWORD 'CHANGE_ME';
        '';

        authentication = ''
          # TYPE  DATABASE  USER  ADDRESS       METHOD
          local   all       postgres            peer
          local   all       all                 scram-sha-256
          host    all       all   127.0.0.1/32  scram-sha-256
          host    all       all   ::1/128       scram-sha-256
        '';

        settings = {
          password_encryption = "scram-sha-256";

          log_connections = true;
          log_disconnections = true;
          log_statement = "ddl"; # 只记录 DDL，避免全量日志开销
          # log_destination = "syslog";
        };

        ensureDatabases = [ username ];

        ensureUsers = [
          {
            name = username;
            ensureClauses = {
              createdb = true;
              # superuser = true;
              # createrole = true;
              # 去掉 superuser 和 createrole，日常开发不需要
            };
          }
        ];
      };
    };
}
