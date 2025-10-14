{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {
    modules'.desktop.services.vicinae.enable = true;

    modules'.shortcuts.global = [
      {
        "SUPER-SPACE" = {
          launch = [
            "bash"
            "-c"
            "vicinae toggle"
          ];
        };
        "SUPER-p" = {
          launch = [
            "bash"
            "-c"
            "vicinae vicinae://extensions/vicinae/clipboard/history"
          ];
        };
      }
    ];
  };
}
