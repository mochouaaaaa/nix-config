{
  lib,
  config,
  ...
}: {
  imports = [
    ../base/home.nix

    ./base
    ./gui/base
    ./desktop/window
  ];
}
