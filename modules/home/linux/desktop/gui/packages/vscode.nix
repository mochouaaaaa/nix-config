{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  desktopCfg = config.modules'.desktop;

  # Dynamically determine the correct password store based on the active DE.
  passwordStore =
    if desktopCfg.kde.enable then
      "kde"
    # GNOME, Hyprland, and Niri all use gnome-keyring in this config.
    else if (desktopCfg.gnome.enable || desktopCfg.hyprland.enable || desktopCfg.niri.enable) then
      "gnome-libsecret"
    # A sensible fallback if no specific DE is matched.
    else
      "basic";

  # Consolidate all command line arguments here.
  vscodeArgs = [
    "--ozone-platform-hint=auto"
    "--enable-features=UseOzonePlatform"
    "--enable-wayland-ime"
    "--gtk-version=4"
    "--password-store=${passwordStore}"
  ];
in
{
  config = lib.mkIf (config.programs.vscode.enable && config.programs.desktop.enable) {

    services.xremap = {
      config = {
        modmap = [
          # {
          #   name = "VSCode";
          #   application.only = [
          #     "code"
          #   ];
          #   remap = {
          #     "SUPER_L" = "Ctrl_L";
          #   };
          # }
        ];
      };
    };

    programs.vscode = {
      package = pkgs.vscode.override {
        commandLineArgs = vscodeArgs;
      };
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles.default = {
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
