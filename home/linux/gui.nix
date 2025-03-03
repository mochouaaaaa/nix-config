{
  lib,
  config,
  ...
}: {
  imports = [
    ../base/home.nix

    ./base
    ./gui
    ./desktop/window
  ];
}
