{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {
    programs.chromium = {
      commandLineArgs = lib.mkAfter [ "--gtk-version=4" ];
    };
  };
}
