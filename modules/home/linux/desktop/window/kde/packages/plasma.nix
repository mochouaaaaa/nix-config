{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.kde;
in
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;
      immutableByDefault = true;
      overrideConfig = true;
      configFile = {
        kdeglobals.General = {
          TerminalApplication = "kitty";
          TerminalService = "kitty.desktop";
        };
        kcminputrc.Mouse = {
          X11LibInputXAccelProfileFlat = true;
          cursorSize = config.home.pointerCursor.size;
        };
        kwinrc.Wayland."InputMethod" = {
          value = "$HOME/.local/state/nix/profile/share/applications/fcitx5-wayland-launcher.desktop";
          shellExpand = true;
        };
        kwinrc."org.kde.kdecoration2".ButtonsOnRight = "";
      };
    };
  };
}
