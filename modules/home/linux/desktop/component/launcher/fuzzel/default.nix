{ config, lib, ... }:
let
  cfg = config.modules.desktop.component.launcher.fuzzel;
in
{

  config = lib.mkIf cfg.enable {

    programs.fuzzel = {
      enable = true;
    };

    modules.desktop.component.launcher._commands = "fuzzel";

  };
}
