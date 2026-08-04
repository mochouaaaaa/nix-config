{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        location = {
          address = "北京";
          auto_locate = false;
          custom_schedule = false;
          longitude = 39.9042;
          sunrise = "";
          sunset = "";
        };
      };
    };
  };
}
