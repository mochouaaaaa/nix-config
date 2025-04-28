{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.packages.vscode;
in
{
  options.modules.packages.vscode = {
    commandLineArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "--no-sandbox"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
      description = "Additional command line arguments to pass to the VSCode binary.";
    };
  };

  config = {
    programs = {
      vscode = {
        # let vscode sync and update its configuration & extensions across devices, using github account.
        profiles.default.userSettings = { };
        package = pkgs.vscode.override {
          commandLineArgs = cfg.commandLineArgs;
        };
      };
    };

    modules.xdg-mime.editors = lib.mkAfter [
      "code.desktop"
      "code-insiders.desktop"
    ];
  };
}
