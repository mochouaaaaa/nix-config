{
  flake.modules.nixos."services.dns" =
    { lib, config, ... }:
    let
      cfg = config.profiles.services.dns;
    in
    {

      environment.systemPackages = [
        cfg.package
      ];

      profiles.services.dns = {
        settings = {
          api = {
            http = "${cfg.webapi}";
          };
          log = {
            level = "warn";
            production = false;
          };

          plugins = lib.mkAfter [
            {
              tag = "pre_sequence";
              type = "sequence";
              args = [
                # 拒绝 HTTPS/SVCB
                {
                  matches = "qtype 65";
                  exec = "$reject_qtype65";
                }
                # 拒绝空域名
                {
                  matches = "qname keyword::";
                  exec = "$reject_null_domain";
                }
                # 广告域名拦截
                {
                  matches = "qname $geosite_ads-all";
                  exec = "$reject_ad";
                }
                # 局域网 PTR 查询优先处理
                {
                  matches = "ptr_ip $geoip_private";
                  exec = "$query_lan";
                }
                # 其他 PTR 查询
                {
                  matches = "qtype 12";
                  exec = "$query_other";
                }
                # ANY 查询
                {
                  matches = "qtype 255";
                  exec = "$query_other";
                }
                # 已有响应则进入对应处理流程
                {
                  exec = "jump has_resp_pre";
                }
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
                inherit (cfg) listen;
              };
            }
            {
              type = "tcp_server";
              args = {
                entry = "sequence";
                inherit (cfg) listen;
              };
            }

          ];
        };
      };
    };

}
