{ lib, ... }:
{

  services = {
    resolved = {
      enable = lib.mkForce false;
      dnssec = "false";
    };
  };
  systemd.services.systemd-resolved.enable = lib.mkForce false;
  networking = {
    useHostResolvConf = lib.mkForce true;
    dhcpcd.extraConfig = ''
      static domain_name_servers=127.0.0.1
    '';
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      users = [
        {
          name = "mochou";
          password = "$2a$10$19Wa96mbnFAokAhfWwfUzuO7T8ebR2RdSjFS0ftPCqCZ5lFGb.yf2";
        }
      ];
      auth_attempts = 5;
      block_auth_min = 15;
      http_proxy = "";
      language = "";
      theme = "auto";

      dns = {
        bind_hosts = [
          "0.0.0.0"
        ];
        port = 53;
        anonymize_client_ip = false;
        ratelimit = 0;
        ratelimit_subnet_len_ipv4 = 24;
        ratelimit_subnet_len_ipv6 = 60;
        ratelimit_whitelist = [ ];
        refuse_any = true;
        upstream_dns = [
          "https://dns.alidns.com/dns-query"
          "quic://dns.alidns.com"
        ];
        upstream_dns_file = "";
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];
        fallback_dns = [ ];
        upstream_mode = "fastest_addr";
        fastest_timeout = "1s";
        allowed_clients = [ ];
        disallowed_clients = [ ];
        blocked_hosts = [
          "version.bind"
          "id.server"
          "hostname.bind"
        ];
        trusted_proxies = [
          "127.0.0.0/8"
          "::1/128"
        ];
        cache_size = 4194304;
        cache_ttl_min = 0;
        cache_ttl_max = 0;
        cache_optimistic = true;
        bogus_nxdomain = [ ];
        aaaa_disabled = true;
        enable_dnssec = true;
        edns_client_subnet = {
          custom_ip = "";
          enabled = true;
          use_custom = false;
        };
        max_goroutines = 300;
        handle_ddr = true;
        ipset = [ ];
        ipset_file = "";
        bootstrap_prefer_ipv6 = false;
        upstream_timeout = "10s";
        private_networks = [ ];
        use_private_ptr_resolvers = false;
        local_ptr_upstreams = [
          "https://dns.alidns.com/dns-query"
          "quic://dns.alidns.com"
        ];
        use_dns64 = false;
        dns64_prefixes = [ ];
        serve_http3 = false;
        use_http3_upstreams = false;
        serve_plain_dns = true;
        hostsfile_enabled = true;
        pending_requests = {
          enabled = true;
        };
      };

      querylog = {
        dir_path = "";
        ignored = [ ];
        interval = "24h";
        size_memory = 1000;
        enabled = true;
        file_enabled = true;
      };
      statistics = {
        dir_path = "";
        ignored = [ ];
        interval = "24h";
        enabled = true;
      };

      filters = [
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/BlueSkyXN/AdGuardHomeRules/master/skyrules.txt";
          name = "skyrules";
          id = 1;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/BlueSkyXN/AdGuardHomeRules/master/all.txt";
          name = "all";
          id = 2;
        }
        {
          enabled = true;
          url = "https://mirror.ghproxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockdns.txt";
          name = "adblockdns";
          id = 3;
        }
      ];
      whitelist_filters = [
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/BlueSkyXN/AdGuardHomeRules/master/ok.txt";
          name = "ok";
          id = 4;
        }
      ];
      user_rules = [
        "||a.magsrv.com/ad-provider.js"
        "||833330.xyz/scripts/ad/*.js"
        "@@||majsoul-hk-client.cn-hongkong.log.aliyuncs.com^$important"
      ];

      log = {
        enabled = true;
        file = "";
        max_backups = 0;
        max_size = 100;
        max_age = 3;
        compress = false;
        local_time = false;
        verbose = false;
      };

    };
  };
}
