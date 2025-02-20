{
  lib,
  config,
  ...
}: {
  imports = [
    ../base/core
    ../base/tools
    ../base/home.nix

    ./base
    ./gui/base
    ./desktop/window
  ];
}
