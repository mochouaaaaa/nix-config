{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

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

  };
}
