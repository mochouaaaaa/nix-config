{
  config,
  lib,
  username,
  pkgs,
  ...
}:
let
  cfg = config.profiles.display-manager.greetd;
in
{
  options.profiles.display-manager.greetd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable greetd.";
    };
    command = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {

    services = {
      greetd = {
        enable = true;
        settings = rec {
          terminal.vt = 1;
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${cfg.command}";
            # command = "${cfg.command}";
            user = username;
          };
          initial_session = default_session;
        };
      };
    };

  };
}
