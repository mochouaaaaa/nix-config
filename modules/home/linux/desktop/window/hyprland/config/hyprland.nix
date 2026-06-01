{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    xdg.configFile = {
      "hypr/.luarc.json".text = ''
        {
          "workspace": {
            "library": [
              "${pkgs.hyprland}/share/hypr/stubs"
            ]
          },
          "diagnostics": {
             "globals": [
                "hl"
             ]
          }
        }
      '';
    }
    // config.profiles.dotfileLink "hypr";

    wayland.windowManager.hyprland = {
      configType = "lua";
      extraConfig = lib.mkBefore ''
        require("init")

        hl.config({
            render = {
                cm_auto_hdr = 1,
            },
            cursor = {
                no_hardware_cursors = false;
                enable_hyprcursor = true;
                -- warp_on_change_workspace = true;
                -- no_warps = true;
            };
        })
      '';
    };

  };
}
