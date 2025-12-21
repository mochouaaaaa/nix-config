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

    programs.vscode = {
      package = pkgs.vscode.override {
        commandLineArgs = vscodeArgs;
      };
      profiles.default = {
        userSettings = {
          "vscode-default-keybindings.removeOSKeybindings" = true;
          "vscode-default-keybindings.macOSKeybindings" = true;
        };
        extensions =
          let
            inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
          in
          [
            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "vscode-default-keybindings";
                publisher = "jbro";
                version = "0.2.51";
                hash = "sha256-SJ+YghLJMWqvNsvhMLLzyPgkAiy/g+WlobXBx0mUGLs=";
              };
            })
          ];
        keybindings = [
          {
            key = "meta+k";
            command = "selectPrevSuggestion";
            when = "config.vscode-default-keybindings.macOSKeybindings && suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || config.vscode-default-keybindings.macOSKeybindings && suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
          }
          {
            key = "ctrl+p";
            command = "-selectPrevSuggestion";
            when = "config.vscode-default-keybindings.macOSKeybindings && suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || config.vscode-default-keybindings.macOSKeybindings && suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
          }
          {
            key = "meta+j";
            command = "selectNextSuggestion";
            when = "config.vscode-default-keybindings.macOSKeybindings && suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || config.vscode-default-keybindings.macOSKeybindings && suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
          }
          {
            key = "ctrl+n";
            command = "-selectNextSuggestion";
            when = "config.vscode-default-keybindings.macOSKeybindings && suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || config.vscode-default-keybindings.macOSKeybindings && suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
          }
          {
            key = "meta+e";
            command = "editor.action.inlineSuggest.hide";
            when = "config.vscode-default-keybindings.macOSKeybindings && inInlineEditsPreviewEditor";
          }
          {
            key = "escape";
            command = "-editor.action.inlineSuggest.hide";
            when = "config.vscode-default-keybindings.macOSKeybindings && inInlineEditsPreviewEditor";
          }
          {
            key = "meta+e";
            command = "editor.action.inlineSuggest.hide";
            when = "config.vscode-default-keybindings.macOSKeybindings && inlineEditIsVisible || config.vscode-default-keybindings.macOSKeybindings && inlineSuggestionVisible";
          }
          {
            key = "escape";
            command = "-editor.action.inlineSuggest.hide";
            when = "config.vscode-default-keybindings.macOSKeybindings && inlineEditIsVisible || config.vscode-default-keybindings.macOSKeybindings && inlineSuggestionVisible";
          }
          {
            key = "meta+e";
            command = "hideSuggestWidget";
            when = "config.vscode-default-keybindings.macOSKeybindings && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "escape";
            command = "-hideSuggestWidget";
            when = "config.vscode-default-keybindings.macOSKeybindings && suggestWidgetVisible && textInputFocus";
          }
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
