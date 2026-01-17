{
  config,
  lib,
  username,
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
  };

  config = lib.mkIf cfg.enable {

    services = {
      greetd = {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = {
            user = username;
          };
        };
      };
    };

  };
}
