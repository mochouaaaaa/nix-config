{ config, lib, ... }:
let

  cfg = config.profiles.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      outputs = {
        "LG Electronics LG HDR 4K 0x00052C1D" = {
          mode = {
            width = 3840;
            height = 2160;
            refresh = 59.951;
          };
          scale = 1.5;
          variable-refresh-rate = "on-demand";
        };
      };
    };
  };
}
