{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.modules'.packages.vscode;
in
{

  options.modules'.packages.vscode = with lib; {
    commandLineArgs = mkOption rec {
      type = types.listOf types.str;
      default = [
        "--no-sandbox"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      description = "Additional command line arguments to pass to the VSCode binary.";
      apply = userValue: default ++ userValue;
    };
  };

  config = {
    programs = {
      vscode = {
        # let vscode sync and update its configuration & extensions across devices; using github account.
        profiles."${username}" = {
          extensions =
            let
              inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
            in
            [
              # (buildVscodeMarketplaceExtension {
              #   mktplcRef = {
              #     name = "MikeCunneen";
              #     publisher = "default-keys-macos";
              #     version = "1.0.0";
              #     hash = "sha256-WHbUl3js9jXNxa1Zn0jydB2uAcXdoca9kVkPGu5OxjY=";
              #   };
              # })
            ];
        };
        package = pkgs.vscode.override {
          commandLineArgs = cfg.commandLineArgs;
        };
      };
    };

    modules'.xdg-mime = {
      editors = [
        "code.desktop"
        "code-insiders.desktop"
      ];
      defaultApplications = {
        # https://github.com/microsoft/vscode/issues/146408
        "x-scheme-handler/vscode" = [
          "code-url-handler.desktop"
        ]; # open `vscode://` url with `code-url-handler.desktop`
        "x-scheme-handler/vscode-insiders" = [
          "code-insiders-url-handler.desktop"
        ]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
      };
    };
  };
}
