{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.modules.packages.database-suite;

  user = "${self.myvars.username}";
in
{
  options.modules.packages.database-suite = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable databases packages.";
    };
  };

  config = lib.mkIf cfg.enable {

    services = {
      redis = {
        servers = {
          "${user}" = {
            user = user;
            enable = true;
            bind = "0.0.0.0";
            unixSocket = "/var/run/redis.sock";
          };
        };
      };

      mysql = {
        enable = true;
        user = user;
        group = user;
      };
    };
  };
}
