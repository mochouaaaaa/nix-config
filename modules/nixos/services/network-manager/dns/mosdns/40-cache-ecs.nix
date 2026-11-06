{ lib, ... }: {
  profiles.services.dns = {
    settings = {
      plugins = lib.mkOrder 150 [

        # --- 缓存插件 (Cache) ---
        {
          tag = "cache_lan";
          type = "cache";
          args = {
            size = 8192;
            lazy_cache_ttl = 86400; # 24小时
          };
        }
        {
          tag = "cache_wan";
          type = "cache";
          args = {
            size = 131072;
            lazy_cache_ttl = 7200;
          };
        }

        # --- ECS 处理器 ---
        {
          tag = "no_ecs";
          type = "ecs_handler";
          args = {
            forward = false;
            preset = "";
            send = false;
            mask4 = 24;
            mask6 = 48;
          };
        }
        {
          tag = "ecs_cn";
          type = "ecs_handler";
          args = {
            forward = false;
            preset = "183.2.172.177"; # 这里建议确认为国内常用 IP
            send = false;
            mask4 = 24;
            mask6 = 48;
          };
        }

        # --- TTL 调整序列 ---
        {
          tag = "ttl_1m";
          type = "sequence";
          args = [ { exec = "ttl 60"; } ];
        }
        {
          tag = "ttl_5m";
          type = "sequence";
          args = [ { exec = "ttl 300"; } ];
        }
        {
          tag = "ttl_1h";
          type = "sequence";
          args = [ { exec = "ttl 3600"; } ];
        }

      ];
    };
  };
}
