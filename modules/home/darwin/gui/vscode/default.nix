{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs.vscode = {
    profiles."${username}" = {
      userSettings = {
        "window.nativeTabs" = false;
        "workbench.activityBar.location" = "top";
        # "editor.fontFamily" = "Menlo, Monaco, Consolas, 'Courier New', monospace";
        # "editor.fontSize" = 12;
        "window.autoDetectColorScheme" = true;
        "workbench.activityBar.visible" = false;
        "workbench.sideBar.location" = "left";
        "workbench.editor.tabCloseButton" = "left";
        "workbench.editor.showIcons" = false;
        "workbench.preferredLightColorTheme" = lib.mkForce "macOS Classic";
        "workbench.preferredDarkColorTheme" = lib.mkForce "macOS Classic Dark v2";
        "workbench.iconTheme" = lib.mkForce "macos-classic-icons";
        "editor.renderLineHighlight" = "none";
        "editor.minimap.enabled" = false;
        "editor.glyphMargin" = false;
        "editor.renderIndentGuides" = true;
        "editor.selectionHighlight" = false;
        "editor.scrollbar.verticalScrollbarSize" = 4;
        "editor.scrollbar.horizontalScrollbarSize" = 4;
      };

      extensions =
        let
          inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
        in
        [
          (buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "theme-macos-classic";
              publisher = "huacnlee";
              version = "1.7.2";
              hash = "sha256-hYBwG6aWD/r96ysoiUDQRTdWzmM/qSladCLVKwPZEQU=";
            };
          })
        ];

    };
  };
}
