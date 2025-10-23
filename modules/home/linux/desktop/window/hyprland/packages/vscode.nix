{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    modules'.packages.vscode.commandLineArgs = [
      "--gtk-version=4"
      "--ozone-platform-hint=auto"
      "--password-store=gnome-libsecret"
    ];

  };
}
