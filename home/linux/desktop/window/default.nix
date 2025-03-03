{
  lib,
  myvars,
  ...
}:
with lib; {
  imports =
    []
    ++ optionals (myvars.desktop.hyprland) [./hyprland ./component]
    ++ optionals (myvars.desktop.hyprland) [./hyprland]
    ++ optionals (myvars.desktop.niri) [./niri]
    ++ optionals (myvars.desktop.gnome) [./gnome]
    ++ optionals (myvars.desktop.kde) [./kde];
}
