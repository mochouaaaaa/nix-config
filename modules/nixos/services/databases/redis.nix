{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.profiles.services.databases.redis;
in
{
  options.profiles.services.databases.redis = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable redis packages.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      redis = {
        servers = {
          "main" = {
            enable = true;
            bind = null;
            port = 6379;

            requirePass = "password";

            settings = {
              maxmemory = "512mb";
              maxmemory-policy = "allkeys-lru"; # 内存满时，删除最近最少使用的 key
              save = [
                "900 1"
                "300 10"
                "60 10000"
              ]; # RDB
            };
            appendOnly = true;

            unixSocket = "/var/run/redis-main/redis.sock";
            unixSocketPerm = 660;
            openFirewall = true;
          };
        };
      };
    };

    users.users.${username}.extraGroups = [ "redis-main" ];
  };

}
