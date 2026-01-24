{
  lib,
  pkgs,
  config,
  ...
}:
let
  formatYaml = pkgs.formats.yaml { };

  cfg = config.profiles.services.dns;
in
{

  config = lib.mkIf cfg.enable {

    profiles.services.dns = {
      settings = {
        api = {
          http = "0.0.0.0:8338";
        };
        log = {
          level = "warn";
          production = false;
        };
        plugins = [
          # --- 基础拒绝插件 ---
          {
            tag = "reject_null_domain";
            type = "sequence";
            args = [
              { exec = "query_summary reject_null_domain"; }
              { exec = "$reject_3"; }
            ];
          }
          {
            tag = "reject_qtype65";
            type = "sequence";
            args = [
              { exec = "query_summary reject_qtype65"; }
              { exec = "$reject_3"; }
            ];
          }
          {
            tag = "reject_ad";
            type = "sequence";
            args = [
              { exec = "query_summary reject_adlist"; }
              { exec = "$reject_3"; }
            ];
          }

          # --- DNS 序列定义 ---
          {
            tag = "dns_nocn";
            type = "fallback";
            args = {
              primary = "nextdns";
              secondary = "quad9";
              threshold = 600;
              always_standby = true;
            };
          }
          {
            tag = "dns_cn";
            type = "fallback";
            args = {
              primary = "ali";
              secondary = "dnspod";
              threshold = 600;
              always_standby = true;
            };
          }

          # --- 序列逻辑包装 ---
          {
            tag = "dns_nocn_seq";
            type = "sequence";
            args = [
              { exec = "query_summary dns_nocn"; }
              { exec = "$dns_nocn"; }
            ];
          }
          {
            tag = "dns_cn_seq";
            type = "sequence";
            args = [
              { exec = "query_summary dns_cn"; }
              { exec = "$dns_cn"; }
            ];
          }
          {
            tag = "local_seq";
            type = "sequence";
            args = [
              { exec = "query_summary local"; }
              { exec = "$local"; }
            ];
          }

          # 这里的 fallback_seq 依然指向 dns_nocn，即 ipleak 泄露的源头
          {
            tag = "fallback_seq";
            type = "sequence";
            args = [
              { exec = "query_summary fallback"; }
              { exec = "$dns_nocn"; }
            ];
          }
          {
            tag = "other_seq";
            type = "sequence";
            args = [
              { exec = "query_summary other"; }
              { exec = "$dns_cn"; }
            ];
          }

          # --- 查询逻辑 ---
          {
            tag = "query_cn";
            type = "sequence";
            args = [
              { exec = "$ecs_cn"; }
              { exec = "$dns_cn_seq"; }
              # 丢弃已知污染 IP
              {
                matches = "resp_ip 61.160.148.90/24 221.228.32.13/24 114.237.67.59/24 117.69.71.58/24 180.109.0.0/16 4.36.66.178 8.7.198.45 37.61.54.158 46.82.174.68 59.24.3.173 64.33.88.161 78.16.49.15 93.46.8.89 159.106.121.75 202.106.1.2 202.181.7.85 203.161.230.171 209.145.54.50 211.94.66.147 216.234.179.13 243.185.187.39";
                exec = "drop_resp";
              }
            ];
          }

          {
            tag = "query_nocn";
            type = "sequence";
            args = [
              { exec = "$no_ecs"; }
              { exec = "$dns_nocn_seq"; }
              {
                matches = "resp_ip $geoip_cn 61.160.148.90/24 221.228.32.13/24 114.237.67.59/24 117.69.71.58/24 180.109.0.0/16 4.36.66.178 8.7.198.45 37.61.54.158 46.82.174.68 59.24.3.173 64.33.88.161 78.16.49.15 93.46.8.89 159.106.121.75 202.106.1.2 202.181.7.85 203.161.230.171 209.145.54.50 211.94.66.147 216.234.179.13 243.185.187.39";
                exec = "drop_resp";
              }
            ];
          }

          {
            tag = "query_fallback";
            type = "sequence";
            args = [
              { exec = "$no_ecs"; }
              { exec = "$fallback_seq"; }
              {
                matches = "resp_ip $geoip_cn 61.160.148.90/24 221.228.32.13/24 114.237.67.59/24 117.69.71.58/24 180.109.0.0/16 4.36.66.178 8.7.198.45 37.61.54.158 46.82.174.68 59.24.3.173 64.33.88.161 78.16.49.15 93.46.8.89 159.106.121.75 202.106.1.2 202.181.7.85 203.161.230.171 209.145.54.50 211.94.66.147 216.234.179.13 243.185.187.39";
                exec = "drop_resp";
              }
            ];
          }

          {
            tag = "query_lan";
            type = "sequence";
            args = [
              { exec = "$cache_lan"; }
              {
                matches = "has_resp";
                exec = "return";
              }
              { exec = "$local_seq"; }
            ];
          }

          {
            tag = "query_other";
            type = "sequence";
            args = [
              { exec = "$no_ecs"; }
              { exec = "$other_seq"; }
            ];
          }

          # --- 响应处理 ---
          {
            tag = "pre_handle";
            type = "sequence";
            args = [
              { exec = "$ttl_1h"; }
              { exec = "accept"; }
            ];
          }
          {
            tag = "main_handle";
            type = "sequence";
            args = [
              { exec = "$ttl_5m"; }
              { exec = "accept"; }
            ];
          }
          {
            tag = "has_resp_pre";
            type = "sequence";
            args = [
              {
                matches = "has_resp";
                exec = "goto pre_handle";
              }
            ];
          }
          {
            tag = "has_resp_main";
            type = "sequence";
            args = [
              {
                matches = "has_resp";
                exec = "goto main_handle";
              }
            ];
          }

          # --- 核心入口序列 ---
          {
            tag = "pre_sequence";
            type = "sequence";
            args = [
              # 【此处建议加入】屏蔽 IPv6 防止泄露
              # { matches = "qtype 28"; exec = "reject 3"; }
              {
                matches = "qtype 65";
                exec = "$reject_qtype65";
              }
              {
                matches = "qname keyword::";
                exec = "$reject_null_domain";
              }
              {
                matches = "qtype 12";
                exec = "$query_other";
              }
              {
                matches = "qtype 255";
                exec = "$query_other";
              }
              {
                matches = "ptr_ip $geoip_private";
                exec = "$query_lan";
              }
              { exec = "jump has_resp_pre"; }
            ];
          }

          {
            tag = "main_sequence";
            type = "sequence";
            args = [
              { exec = "$cache_wan"; }
              { exec = "jump has_resp_main"; }
              {
                matches = "qname $geosite_gfw";
                exec = "$query_nocn";
              }
              { exec = "jump has_resp_main"; }
              {
                matches = "qname $geosite_location-!cn";
                exec = "$query_nocn";
              }
              { exec = "jump has_resp_main"; }
              {
                matches = "qname $geosite_cn";
                exec = "$query_cn";
              }
              { exec = "jump has_resp_main"; }
              # Fallback 兜底
              { exec = "$no_ecs"; }
              { exec = "$query_fallback"; }
              { exec = "jump has_resp_main"; }
            ];
          }

          {
            tag = "sequence";
            type = "sequence";
            args = [
              { exec = "metrics_collector metrics"; }
              { exec = "$pre_sequence"; }
              { exec = "$main_sequence"; }
            ];
          }

          # 在同一端口启动 udp 和 tcp 服务器。
          {
            type = "udp_server";
            args = {
              entry = "sequence";
              listen = cfg.listen;
            };
          }
          {
            type = "tcp_server";
            args = {
              entry = "sequence";
              listen = cfg.listen;
            };
          }

        ];
      };
    };

  };

}
