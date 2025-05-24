{
  self,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.dm.greetd;
in
{
  options.modules.dm.greetd = {
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
        settings = rec {
          terminal.vt = 1;
          default_session = {
            user = self.myvars.username;
            command = "${lib.getExe pkgs.greetd.tuigreet}";
          };
          initial_session = default_session // {
            command = "sh -c 'sleep 2; ${default_session.command} '";
          };
        };
      };
    };
  };
}
