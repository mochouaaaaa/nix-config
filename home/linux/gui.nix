{
  lib,
  config,
  ...
}: {
  imports = [
    ../base/core
    ../base/tui
    ../base/home.nix

    ./base
    ./gui/base
    ./desktop/window
  ];
}
