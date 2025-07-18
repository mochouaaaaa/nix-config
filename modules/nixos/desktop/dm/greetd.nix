{
  config,
  lib,
  username,
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

    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
        };
        background = {
          path = "/home/${username}/.current_wallpaper";
        };
        widget.clock = {
          format = "%a %H:%M";
          resolution = "500ms";
          timezone = "Asia/Shanghai";
          label_width = 150;
        };
      };
      cageArgs = [
        # "-s"
        "-m"
        "last"
      ];
    };

    services = {
      greetd = {
        settings = {
          terminal.vt = 1;
          default_session = {
            user = username;
          };
          # initial_session = default_session;
          # // {command = "sh -c 'sleep 2; ${default_session.command} '";};
        };
      };
    };
  };
}
