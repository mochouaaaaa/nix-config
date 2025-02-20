{
  pkgs,
  config,
  lib,
  myvars,
  ...
} @ args:
with lib; {
  imports = [./component];
  config = mkMerge (
    [
    ]
    ++ optionals (myvars.desktop.hyprland) (import ./hyprland args)
    ++ optionals (myvars.desktop.niri) (import ./niri args)
    ++ optionals (myvars.desktop.gnome) (import ./gnome args)
  );
}
