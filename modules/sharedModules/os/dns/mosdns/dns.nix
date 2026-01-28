{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.services.dns;
in
{

  config = lib.mkIf cfg.enable {

    profiles.services.dns = {
      settings = {
        plugins = [

          # --- Google DNS (DoH/DoT/H3) ---
          {
            tag = "google";
            type = "forward";
            args = {
              concurrent = 3;
              upstreams = [
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "2001:4860:4860::6464";
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "2001:4860:4860::0064";
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "2001:4860:4860::8844";
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "2001:4860:4860::8888";
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "8.8.4.4";
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "8.8.8.8";
                }
                {
                  addr = "tls://dns.google";
                  dial_addr = "8.8.4.4";
                  enable_pipeline = true;
                }
                {
                  addr = "tls://dns.google";
                  dial_addr = "2001:4860:4860::8888";
                  enable_pipeline = true;
                }
                {
                  addr = "tls://dns.google";
                  dial_addr = "8.8.8.8";
                  enable_pipeline = true;
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "2001:4860:4860::8844";
                  enable_http3 = true;
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "8.8.4.4";
                  enable_http3 = true;
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "2001:4860:4860::8888";
                  enable_http3 = true;
                }
                {
                  addr = "https://dns.google/dns-query";
                  dial_addr = "8.8.8.8";
                  enable_http3 = true;
                }
              ];
            };
          }

          # --- Cloudflare DNS ---
          {
            tag = "cloudflare";
            type = "forward";
            args = {
              concurrent = 3;
              upstreams = [
                {
                  addr = "https://1.1.1.1/dns-query";
                  dial_addr = "1.1.1.1";
                }
                {
                  addr = "tls://1.1.1.1";
                  dial_addr = "1.1.1.1";
                  enable_pipeline = true;
                }
              ];
            };
          }

          # --- NextDNS ---
          {
            tag = "nextdns";
            type = "forward";
            args = {
              concurrent = 2;
              upstreams = [
                {
                  addr = "https://dns.nextdns.io/\${DNS_ID}";
                  dial_addr = "\${DNS_V41}";
                  enable_http3 = true;
                }
                {
                  addr = "https://dns.nextdns.io/\${DNS_ID}";
                  dial_addr = "\${DNS_V61}";
                  enable_http3 = true;
                }
                {
                  addr = "tls://\${DNS_ID}.dns.nextdns.io";
                  dial_addr = "\${DNS_V42}";
                  enable_pipeline = true;
                }
              ];
            };
          }

          # --- Quad9 ---
          {
            tag = "quad9";
            type = "forward";
            args = {
              concurrent = 2;
              upstreams = [
                {
                  addr = "https://dns11.quad9.net/dns-query";
                  dial_addr = "9.9.9.11";
                }
                {
                  addr = "https://dns11.quad9.net/dns-query";
                  dial_addr = "2620:fe::11";
                }
                {
                  addr = "tls://dns11.quad9.net";
                  dial_addr = "9.9.9.11";
                  enable_pipeline = true;
                }
                {
                  addr = "tls://dns11.quad9.net";
                  dial_addr = "2620:fe::11";
                  enable_pipeline = true;
                }
              ];
            };
          }

          # --- 阿里 DNS ---
          {
            tag = "ali";
            type = "forward";
            args = {
              concurrent = 3;
              upstreams = [
                {
                  addr = "https://dns.alidns.com/dns-query";
                  dial_addr = "223.6.6.6";
                }
                {
                  addr = "tls://dns.alidns.com";
                  dial_addr = "2400:3200:baba::1";
                  enable_pipeline = true;
                }
                {
                  addr = "tls://dns.alidns.com";
                  dial_addr = "223.5.5.5";
                  enable_pipeline = true;
                }
                {
                  addr = "https://dns.alidns.com/dns-query";
                  dial_addr = "223.5.5.5";
                  enable_http3 = true;
                }
                {
                  addr = "https://dns.alidns.com/dns-query";
                  dial_addr = "2400:3200::1";
                  enable_http3 = true;
                }
              ];
            };
          }

          # --- DNSPod ---
          {
            tag = "dnspod";
            type = "forward";
            args = {
              concurrent = 3;
              upstreams = [
                {
                  addr = "https://doh.pub/dns-query";
                  dial_addr = "1.12.12.12";
                }
                {
                  addr = "https://doh.pub/dns-query";
                  dial_addr = "120.53.53.53";
                }
                {
                  addr = "tls://dot.pub";
                  dial_addr = "1.12.12.12";
                  enable_pipeline = true;
                }
                {
                  addr = "tls://dot.pub";
                  dial_addr = "120.53.53.53";
                  enable_pipeline = true;
                }
              ];
            };
          }

          # --- 本地主路由 DNS ---
          {
            tag = "local";
            type = "forward";
            args = {
              concurrent = 1;
              upstreams = [ { addr = "udp://192.168.1.1:53"; } ];
            };
          }

          # --- 拒绝类插件序列 ---
          {
            tag = "reject_2";
            type = "sequence";
            args = [ { exec = "reject 2"; } ];
          }
          {
            tag = "reject_3";
            type = "sequence";
            args = [ { exec = "reject 3"; } ];
          }
          {
            tag = "reject_5";
            type = "sequence";
            args = [ { exec = "reject 5"; } ];
          }

        ];
      };
    };
  };
}
