{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    modules.packages.vscode.commandLineArgs = lib.mkAfter [
      "--gtk-version=4"
      "--ozone-platform-hint=auto"
      "--password-store=kde"
    ];

  };
}
