{
  profiles.services.dns = {
    settings = {
      plugins = [

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

      ];
    };
  };
}
