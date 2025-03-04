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
    ++ lib.optionals (myvars.desktop.hyprland) [./gui/desktop/hyprland]
    ++ lib.optionals (myvars.desktop.niri) [./gui/desktop/niri]
    ++ lib.optionals (myvars.desktop.kde) [./gui/desktop/kde];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
