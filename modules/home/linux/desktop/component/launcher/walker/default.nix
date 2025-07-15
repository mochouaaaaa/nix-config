{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.component.launcher.walker;
in
{
  imports = [ inputs.walker.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {

    modules.desktop.component.launcher._commands = "walker";

    programs.walker = {
      enable = true;
      runAsService = true;

      # All options from the config.json can be used here.
      config = {
        search.placeholder = "Example";
        ui.fullscreen = true;
        list = {
          height = 200;
        };
        websearch.prefix = "?";
        switcher.prefix = "/";
      };

    };
  };
}
