{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.display-manager.gdm;
in
{
  options.modules.display-manager.gdm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable gdm.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
        autoLogin.delay = 0;
        settings = {
          daemon = {
            AutomaticLoginEnable = true;
            AutomaticLogin = "${username}";
          };
        };
      };
    };
  };
}
