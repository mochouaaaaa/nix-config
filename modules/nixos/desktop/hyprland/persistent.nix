{ config, lib, ... }:
let
  cfgHyprland = config.profiles.desktop.hyprland;
in
{

  config = lib.mkIf cfgHyprland.enable {

    profiles.persistent.hmDirectories = [
      ".local/state/caelestia"
      ".cache/noctalia"
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
    ];

  };

}
