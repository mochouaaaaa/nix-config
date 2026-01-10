{ config, lib, ... }:
let
  cfgNiri = config.profiles.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    profiles.persistent.hmDirectories = [
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
      ".cache/noctalia"
      ".config/noctalia"
    ];

  };

}
