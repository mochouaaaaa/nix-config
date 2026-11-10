{
  flake.modules.nixos."services.dns" = { lib, ... }: {
    profiles.services.dns = {
      settings = {
        plugins = lib.mkOrder 180 [
          {
            tag = "dns_nocn";
            type = "fallback";
            args = {
              primary = "nextdns";
              secondary = "quad9";
              threshold = 600;
              always_standby = false; # 并行
            };
          }
          {
            tag = "dns_cn";
            type = "fallback";
            args = {
              primary = "ali";
              secondary = "dnspod";
              threshold = 600;
              always_standby = false;
            };
          }
        ];
      };
    };
  };
}
