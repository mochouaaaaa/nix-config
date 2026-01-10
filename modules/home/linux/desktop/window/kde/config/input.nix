{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma.input = {
      keyboard = {
        model = "pc104";
        layouts = [
          {
            layout = "us";
            variant = "mac";
          }
        ];
        numlockOnStartup = "unchanged";
        repeatDelay = 200;
        repeatRate = 40;
      };
    };
  };
}
