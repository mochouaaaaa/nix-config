{ config, lib, ... }:
let
  cfgHyprland = config.profiles.desktop.hyprland;
in
{

  config = lib.mkIf cfgHyprland.enable {

    profiles.persistent.hmDirectories = [
      ".cache/noctalia"
      ".local/state/noctalia"
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
    ];

  };

}
