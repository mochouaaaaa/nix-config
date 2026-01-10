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

        programs.niri = {
          settings.window-rules = [
            {
              opacity = 0.85;
              matches = [
                {
                  app-id = "^(neovide)$";
                }
              ];
            }
          ];
        };

      })

    ]
  );

}
