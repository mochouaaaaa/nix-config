{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.virtual;
in
{
  config = lib.mkIf (cfg.virtualbox.enable && config.profiles.desktop.enable) {
    users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

    virtualisation = {
      virtualbox = {
        host = {
          enable = true;
          enableExtensionPack = true;
        };
        guest = {
          enable = true;
          dragAndDrop = true;
        };
      };
    };
  };
}
