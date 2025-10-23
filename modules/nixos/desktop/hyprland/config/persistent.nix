{ config, lib, ... }:
let
  cfgHyprland = config.modules'.desktop.hyprland;
in
{

  config = lib.mkIf cfgHyprland.enable {

    modules'.persistent.hmDirectories = [
      ".local/state/caelestia"
      ".config/caelestia"
      ".cache/noctalia"
      ".config/noctalia"
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
    ];

  };

}
