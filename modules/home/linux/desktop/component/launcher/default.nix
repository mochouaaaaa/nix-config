{ config, lib, ... }:
let
  cfg = config.modules'.desktop.component.launcher;
in
{
  imports = lib.importModule' ./.;

  options.modules'.desktop.component.launcher = with lib; {
    fuzzel = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable fuzzel component.";
      };
    };
    rofi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable rofi component.";
      };
    };
    _commands = mkOption {
      type = types.str;
      description = "Commands to execute when the launcher is launched.";
    };
  };

  config = lib.mkIf (cfg.fuzzel.enable || cfg.rofi.enable) {

    # set keymap
    modules'.shortcuts.global = [
      {
        "SUPER-SPACE" = {
          launch = [
            "bash"
            "-c"
            cfg._commands
          ];
        };
      }
    ];

  };
}
