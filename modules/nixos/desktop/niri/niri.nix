{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.niri;
  cfgNiri = config.programs.niri;
in
{

  config = lib.mkIf cfg.enable {

    profiles.display-manager.greetd = {
      enable = true;
      command = "niri-session";
    };

    programs.niri = {
      enable = true;
    };

    systemd.user.services.niri.enableDefaultPath = false;

    home-manager.sharedModules = [
      {
        config = lib.mkMerge [

          {
            wayland.windowManager.niri = {
              package = lib.mkForce cfgNiri.package;
            };
          }

        ];
      }
    ];

  };
}
