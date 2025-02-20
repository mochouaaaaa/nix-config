{
  pkgs,
  config,
  lib,
  myvars,
  ...
} @ args:
with lib; {
  imports = [./component];
  config =  (mkMerge ([
    ]
    ++ optionals (myvars.desktop.hyprland) (import ./hyprland args)));
}
