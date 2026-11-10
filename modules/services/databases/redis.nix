{

  flake.modules.darwin."services.redis" = {
    services = {
      redis = {
        enable = true;
        bind = "0.0.0.0";
        # extraConfig = '''';
        unixSocket = "/var/run/redis.sock";
      };
    };
  };

  flake.modules.nixos."services.redis" =
    {
      config,

      username,
      ...
    }:
    {
      services.redis.servers."main" = {
        enable = true;
        port = 6379;

        bind = "0.0.0.0";
        openFirewall = true;

        # 密码用文件注入，不要明文
        # requirePassFile = config.age.secrets.redis-password.path;
        requirePass = "letmein!";

        save = [
          [
            900
            1
          ]
          [
            300
            10
          ]
          [
            60
            10000
          ]
        ];
        appendOnly = true;

        settings = {
          maxmemory = "512mb";
          maxmemory-policy = "allkeys-lru";
        };

        unixSocket = "/run/redis-main/redis.sock";
        unixSocketPerm = 660;
      };

      users.users.${username}.extraGroups = [ "redis-main" ];

      networking.firewall.extraInputRules = ''
        ip saddr 192.168.1.0/24 tcp dport ${config.services.redis.services."main".port} accept
      '';
    };
}
