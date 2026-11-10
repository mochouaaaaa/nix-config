{
  flake.modules.nixos."services.dns" = {
    profiles.services.dns = {
      settings = {
        plugins = [
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

        ];
      };
    };
  };
}
