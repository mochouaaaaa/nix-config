{
  flake.modules.nixos."services.proxy" =
    {
      config,
      lib,
      options,
      ...
    }:
    let
      cfg = config.profiles.services.proxy;
      hasMosdns = options ? profiles.services.dns;
    in
    {
      config = lib.mkIf cfg.dae.enable {

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
                ${lib.optionalString hasMosdns ''
                  mosdns: 'tcp+udp://${config.profiles.services.dns.listen}'
                ''}
                ${lib.optionalString (!hasMosdns) ''
                  alidns: 'udp://223.5.5.5:53'
                ''}
              }

              routing {
                request {
                  # 屏蔽特定域名
                  qname(suffix: mcdn.bilivideo.com) -> reject
                  qname(suffix: mcdn.bilivideo.cn) -> reject
                  qname(suffix: edge.mountaintoys.cn) -> reject
                  qname(suffix: h2.smtcdns.net) -> reject

                  # 其他 DNS 请求交给当前可用的上游
                  ${lib.optionalString hasMosdns "fallback: mosdns"}
                  ${lib.optionalString (!hasMosdns) "fallback: alidns"}
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

              # MosDNS 跳过 DAE DNS 二次接管
              ${lib.optionalString hasMosdns "pname(mosdns) -> must_rules"}

              # 系统及局域网相关服务
              pname(NetworkManager) -> direct
              pname(caddy) -> direct
              pname(kdeconnectd) -> direct
              pname(qbittorrent) -> direct
              pname(cloudflared) -> direct

              # ==========================================
              # 域名规则
              # ==========================================

              # Steam 国内相关服务直连
              domain(suffix: cm.steampowered.com) -> direct
              domain(suffix: steamserver.net) -> direct
              domain(geosite: steam@cn) -> direct
              domain(suffix: bing.com) -> direct

              # Epic 国内服务直连
              domain(geosite: epicgames@cn) -> direct

              # Cloudflare 国内服务直连
              domain(geosite: cloudflare@cn) -> direct

              # Microsoft 国内服务直连
              domain(geosite: microsoft@cn) -> direct

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
    };
}
