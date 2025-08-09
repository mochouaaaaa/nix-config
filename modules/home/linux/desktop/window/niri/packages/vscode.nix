{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    modules'.packages.vscode.commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--password-store=gnome-libsecret"
      "--wayland-text-input-version=3"
    ];
  };
}
