{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{

  config = lib.mkIf (cfg.enable) {
    modules'.desktop.services.vicinae.enable = true;

    programs.niri.settings.binds = with config.lib.niri.actions; {
      "Mod+Space".action = spawn "vicinae" "toggle";
      "Mod+P".action = spawn "vicinae" "vicinae://extensions/vicinae/clipboard/history";
    };
  };
}
