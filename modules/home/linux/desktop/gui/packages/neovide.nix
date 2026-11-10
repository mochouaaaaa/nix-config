{ lib, config, ... }:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf (config.profiles.desktop.enable) (
    lib.mkMerge [

      {
        programs.neovide = {
          settings = {
            wayland-app-id = "org.neovim.Neovide";
          };
        };
      }

      (lib.mkIf (cfg.niri.enable) {

        wayland.windowManager.niri.settings = {
          _children = [
            {
              window-rule._children = [
                {
                  match._props.app-id = "^(neovide)$";
                }
                { opacity = 0.85; }
              ];
            }
          ];
        };

      })

    ]
  );

}
