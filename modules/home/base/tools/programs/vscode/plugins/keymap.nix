{ config, ... }:
let
  cfg = config.keymaps;
in
{
  programs = {
    vscode = {
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles = {
        default = {
          keybindings = [
            {
              key = "${cfg.Super}+j";
              command = "workbench.action.focusBelowGroup";
            }
            {
              key = "${cfg.Super}+k";
              command = "workbench.action.focusAboveGroup";
            }
            {
              key = "${cfg.Super}+h";
              command = "workbench.action.focusLeftGroup";
            }
            {
              key = "${cfg.Super}+l";
              command = "workbench.action.focusRightGroup";
            }
            {
              key = "${cfg.Super}+e";
              command = "workbench.action.toggleSidebarVisibility";
            }
            {
              key = "ctrl+${cfg.Super}+l";
              command = "workbench.action.splitEditorRight";
            }
            {
              key = "ctrl+${cfg.Super}+h";
              command = "workbench.action.splitEditorLeft";
            }
            {
              key = "ctrl+${cfg.Super}+k";
              command = "workbench.action.splitEditorDown";
            }
            {
              key = "ctrl+${cfg.Super}+j";
              command = "workbench.action.splitEditorUp";
            }
          ];
        };
      };
    };
  };
}
