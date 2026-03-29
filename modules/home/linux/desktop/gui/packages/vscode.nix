{
  lib,
  pkgs,
  config,
  ...
}:
let
  desktopCfg = config.profiles.desktop;
in
{

  options.profiles.packages.vscode = {
    passwordStore = lib.mkOption {
      type = lib.types.str;
      default =
        if desktopCfg.kde.enable then
          "kde"
        # GNOME, Hyprland, and Niri all use gnome-keyring in this config.
        else if (desktopCfg.gnome.enable || desktopCfg.hyprland.enable || desktopCfg.niri.enable) then
          "gnome-libsecret"
        # A sensible fallback if no specific DE is matched.
        else
          "basic";
    };
  };

  config = lib.mkIf (config.programs.vscode.enable && desktopCfg.enable) {

    programs.vscode = {
      package = pkgs.vscode-fhs;
      # package = pkgs.vscode-fhs.override {
      #   commandLineArgs = [
      #     "--ozone-platform-hint=auto"
      #     "--enable-features=UseOzonePlatform"
      #     "--enable-wayland-ime"
      #     "--gtk-version=4"
      #     "--password-store=${config.profiles.packages.vscode.passwordStore}"
      #   ];
      # };
      profiles.default = {
        userSettings = {
          "vscode-default-keybindings.removeOSKeybindings" = true;
          "vscode-default-keybindings.macOSKeybindings" = true;
          "qt-qml.doNotAskForQmllsDownload" = true;
          "qt-qml.qmlls.customExePath" = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
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
            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "qt-qml";
                publisher = "TheQtCompany";
                version = "1.7.0";
                hash = "sha256-QjfvZIcE4LcJU93YiYN/zykEluHtR7zVOwYiPL0k+cQ=";
              };
              meta = {
                license = lib.licenses.gpl3Plus;
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

    xdg.mimeApps.defaultApplicationPackages = [ config.programs.vscode.package ];
  };
}
