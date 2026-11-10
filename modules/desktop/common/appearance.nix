{
  flake.modules.homeManager."desktop.common" = {
    # 光标由合成器控制，Home Manager 不接管
    # home.pointerCursor.enable = false;

    # 4K 显示器 DPI（仅对 X11/XWayland 应用有效）
    xresources.properties = {
      "Xft.dpi" = 150;
      "*.dpi" = 150;
    };

    home.preferXdgDirectories = true;

    # 不用 GTK 主题引擎
    gtk.enable = false;
  };
}
