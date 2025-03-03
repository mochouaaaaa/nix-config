{
  pkgs,
  config,
  lib,
  myvars,
  ...
}: {
  imports =
    [
      ../base.nix
      ./base

      ./gui/game
    ]
    ++ lib.optionals (myvars.desktop.hyprland) [./gui/desktop/hyprland.nix]
    ++ lib.optionals (myvars.desktop.niri) [./gui/desktop/niri.nix]
    ++ lib.optionals (myvars.desktop.kde) [./gui/desktop/kde.nix];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
