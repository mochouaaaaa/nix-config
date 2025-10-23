{ config, lib, ... }:
let
  cfgNiri = config.modules'.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    modules'.persistent.hmDirectories = [
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
      ".cache/noctalia"
      ".config/noctalia"
    ];

  };

}
