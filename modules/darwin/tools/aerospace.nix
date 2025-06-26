{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages.aerospace;
in
{
  options.modules.packages.aerospace = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable aerospace packages.";
    };
  };

  config = lib.mkIf cfg.enable {

    services.aerospace = {
      enable = true;
      settings = {
        start-at-login = true;
        mode.main.binding = {
          cmd-left = "focus left";
          cmd-down = "focus down";
          cmd-up = "focus up";
          cmd-right = "focus right";

          # move
          ctrl-cmd-left = "move left";
          ctrl-cmd-down = "move down";
          ctrl-cmd-up = "move up";
          ctrl-cmd-right = "move right";

          # window resize
          ctrl-shift-left = "resize smart -50";
          ctrl-shift-down = "resize smart 50";
          ctrl-shift-up = "resize smart-opposite -50";
          ctrl-shift-right = "resize smart-opposite 50";

          # focus workspace
          cmd-1 = "workspace 1";
          cmd-2 = "workspace 2";
          cmd-3 = "workspace 3";
          cmd-4 = "workspace 4";
          cmd-5 = "workspace 5";

          # move window to workspace
          cmd-shift-1 = "move-node-to-workspace 1";
          cmd-shift-2 = "move-node-to-workspace 2";
          cmd-shift-3 = "move-node-to-workspace 3";
          cmd-shift-4 = "move-node-to-workspace 4";
          cmd-shift-5 = "move-node-to-workspace 5";

          # switch workspace
          cmd-tab = "workspace-back-and-forth";
        };
      };
    };
  };
}
