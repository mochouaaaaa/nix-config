{
  flake.modules.nixos."services.dns" = { lib, ... }: {
    profiles.services.dns = {
      settings = {
        plugins = lib.mkOrder 200 [
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
        ];
      };
    };
  };
}
