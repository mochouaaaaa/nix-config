{ config, lib, ... }:
{

  config = lib.mkIf config.profiles.desktop.enable {

    profiles.packages.rime = {
      defaultCustomYaml = {
        patch = {
          "__include" = "wanxiang_suggested_default:/";

          "menu/page_size" = 9;
          "style/candidate_list_layout" = "linear";
          "style/translucency" = true;
          "select_keys" = "123456789";

        };
      };
    };

  };

}
