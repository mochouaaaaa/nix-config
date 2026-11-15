{
  flake.modules.nixos."services.proxy" =
    {
      config,
      options,
      ...
    }:
    let
      cfg = config.profiles.services.proxy;
      hasMosdns = options ? profiles.services.dns;

      customDNS =
        if hasMosdns then "tcp+udp://${config.profiles.services.dns.listen}" else "udp://223.5.5.5:53";
    in
    {

      services.dae = {
        enable = true;

        config = ''
          global {
            log_level: warning
            wan_interface: auto
            dial_mode: domain++
            auto_config_kernel_parameter: true
            disable_waiting_network: true
          }

          # Mihomo SOCKS5 出口
          node {
            mihomo: 'socks5://${cfg.mihomo.address}:${toString cfg.mihomo.socks.port}'
          }

          # DNS：优先使用可选的 MosDNS，否则直接使用 AliDNS
          dns {
            upstream {
              customDNS: '${customDNS}'
            }

            routing {
              request {
                # 屏蔽特定域名
                qname(suffix: mcdn.bilivideo.com) -> reject
                qname(suffix: mcdn.bilivideo.cn) -> reject
                qname(suffix: edge.mountaintoys.cn) -> reject
                qname(suffix: h2.smtcdns.net) -> reject

                fallback: customDNS
              }
            }
          }

          # 代理出口
          group {
            mihomo {
              policy: fixed(0)
            }
          }

          routing {
            # ==========================================
            # 进程规则
            # ==========================================

            # 代理程序自身直连，防止代理环路
            pname(mihomo) -> must_direct
            pname(clash) -> must_direct
            pname(clash-meta) -> must_direct
            pname(mosdns) -> must_rules

            # 系统及局域网相关服务
            pname(NetworkManager) -> direct
            pname(caddy) -> direct
            pname(kdeconnectd) -> direct
            pname(qbittorrent) -> direct


            # ==========================================
            # IP 规则
            # ==========================================

            # 私有地址及局域网直连
            dip(geoip:private) -> direct

            # 中国大陆 IP 直连
            dip(geoip:cn) -> direct

            # ==========================================
            # 最终规则
            # ==========================================

            # 中国大陆域名直连
            domain(geosite:cn) -> direct

            # 其他流量走 Mihomo
            fallback: mihomo
          }
        '';
      };

    };
}
