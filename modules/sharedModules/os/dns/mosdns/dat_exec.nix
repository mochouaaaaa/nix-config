{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.profiles.services.dns;

  dns-rules = inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.dns-rules;
in
{

  config = lib.mkIf cfg.enable {

    profiles.services.dns = {
      settings = {
        plugins = [
          ################## 数据源 ################
          {
            tag = "geoip_private";
            type = "ip_set";
            args = {
              files = [ "${dns-rules}/share/mosdns/geoip_private.txt" ];
            };
          }
          {
            tag = "geoip_cn";
            type = "ip_set";
            args = {
              files = [ "${dns-rules}/share/mosdns/geoip_cn.txt" ];
            };
          }

          {
            tag = "geosite_cn";
            type = "domain_set";
            args = {
              files = [ "${dns-rules}/share/mosdns/geosite_cn.txt" ];
            };
          }
          {
            tag = "geosite_gfw";
            type = "domain_set";
            args = {
              files = [ "${dns-rules}/share/mosdns/geosite_gfw.txt" ];
            };
          }
          {
            tag = "geosite_location-!cn";
            type = "domain_set";
            args = {
              files = [ "${dns-rules}/share/mosdns/geosite_geolocation-!cn.txt" ];
            };
          }
          {
            tag = "geosite_ads-all";
            type = "domain_set";
            args = {
              files = [ "${dns-rules}/share/mosdns/geosite_category-ads-all.txt" ];
            };
          }

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
              lazy_cache_ttl = 86400;
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
              preset = "89.185.27.14"; # 这里建议确认为国内常用 IP
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
  };
}
