{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        osd = {
          autoHideMs = 3000;
          enabled = true;
          enabledTypes = [
            0
            1
            2
            3
            4
          ];
          location = "bottom";
          monitors = [ ];
          offset_y = 30;
          overlayLayer = true;
          position = "bottom_center";
          position_vertical = "bottom_center";
        };
      };
    };
  };
}
