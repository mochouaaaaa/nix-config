{ config, lib, ... }:
let

  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      outputs = {
        "LG Electronics LG HDR 4K 0x00052C1D" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 59.951;
          };
          scale = 1;
          variable-refresh-rate = "on-demand";
        };
      };
    };
  };
}
