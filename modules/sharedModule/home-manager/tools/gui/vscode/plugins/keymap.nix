{
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.modules'.keymaps;
in
{
  programs = {
    vscode = {
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles = {
        "${username}" = {
          userSettings = {
            # "intellij-idea-keybindings.useCamelHumpsWords" = true;
          };
          extensions =
            let
              inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
            in
            [
              # (buildVscodeMarketplaceExtension {
              #   mktplcRef = {
              #     name = "intellij-idea-keybindings";
              #     publisher = "k--kato";
              #     version = "1.7.5";
              #     hash = "sha256-DOSe0UhNMj6FRyHylnKYQsyhSLQQFvGfcmOBZSw+nVo=";
              #   };
              # })
            ];

          keybindings = [
            # {
            #   key = "${cfg.Super}+e";
            #   command = "workbench.action.toggleSidebarVisibility";
            #   when = "editorTextFocus";
            # }
            # {
            #   key = "${cfg.Super}+l";
            #   command = "workbench.action.focusRightGroup";
            # }
            # {
            #   key = "${cfg.Super}+k cmd+right";
            #   command = "-workbench.action.focusRightGroup";
            # }
            # {
            #   key = "${cfg.Super}+h";
            #   command = "workbench.action.focusLeftGroup";
            # }
            # {
            #   key = "${cfg.Super}+k cmd+left";
            #   command = "-workbench.action.focusLeftGroup";
            # }
            #
            # # Toggle Sidebar Visibility
            # {
            #   key = "${cfg.Super}+e";
            #   command = "workbench.action.toggleSidebarVisibility";
            # }
            # {
            #   key = "${cfg.Super}+b";
            #   command = "-workbench.action.toggleSidebarVisibility";
            # }
            #
            # # Split Editors
            # {
            #   key = "ctrl+cmd+l";
            #   command = "workbench.action.splitEditorRight";
            # }
            # {
            #   key = "ctrl+cmd+k";
            #   command = "workbench.action.splitEditorUp";
            # }
            # {
            #   key = "ctrl+cmd+j";
            #   command = "workbench.action.splitEditorDown";
            # }
            # {
            #   key = "ctrl+cmd+h";
            #   command = "workbench.action.splitEditorLeft";
            # }
            # {
            #   key = "${cfg.Super}+j";
            #   command = "selectNextSuggestion";
            #   when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
            # }
            # {
            #   key = "ctrl+down";
            #   command = "-selectNextSuggestion";
            #   when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
            # }
            # {
            #   key = "${cfg.Super}+k";
            #   command = "selectPrevSuggestion";
            #   when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
            # }
            # {
            #   key = "ctrl+up";
            #   command = "-selectPrevSuggestion";
            #   when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
            # }
            # {
            #   key = "shift+${cfg.Super}+f";
            #   command = "workbench.action.findInFiles";
            # }
            # {
            #   key = "ctrl+shift+f";
            #   command = "-workbench.action.findInFiles";
            # }
          ];
        };
      };
    };
  };
}
