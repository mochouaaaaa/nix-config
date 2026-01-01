{
  lib,
  ...
}:
{
  programs.zed-editor.enable = lib.mkForce false;
  programs.vscode = {
    profiles.default = {
      userSettings = {
        # "window.nativeTabs" = false;
        # "workbench.activityBar.location" = "top";
        # "editor.fontFamily" = "Menlo, Monaco, Consolas, 'Courier New', monospace";
        # "editor.fontSize" = 12;
        # "window.autoDetectColorScheme" = true;
        # "workbench.activityBar.visible" = false;
        # "workbench.sideBar.location" = "left";
        # "workbench.editor.tabCloseButton" = "left";
        # "workbench.editor.showIcons" = false;
        # "editor.renderLineHighlight" = "none";
        # "editor.minimap.enabled" = false;
        # "editor.glyphMargin" = false;
        # "editor.renderIndentGuides" = true;
        # "editor.selectionHighlight" = false;
        # "editor.scrollbar.verticalScrollbarSize" = 4;
        # "editor.scrollbar.horizontalScrollbarSize" = 4;
      };
    };
  };
}
