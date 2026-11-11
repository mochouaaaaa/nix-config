{ self, ... }: {
  flake.modules.homeManager._default-apps =
    { pkgs, ... }:
    let
      # 按功能分组的包，便于维护
      documentViewers = [
        pkgs.evince # PDF/PostScript 查看器
        # pkgs.loupe # 图片查看器
      ];

      fileManagers = [
        pkgs.file-roller # 归档管理器（ZIP/TAR 等）
      ];

    in
    {

      home.packages = documentViewers ++ fileManagers;

      # 只把真正需要作为默认应用的包放进来
      # font-manager 不设默认，避免意外关联字体文件
      xdg.mimeApps.defaultApplicationPackages = documentViewers ++ fileManagers;

    };

  flake.modules.homeManager."desktop.hyprland" = {
    imports = [
      self.modules.homeManager._default-apps
    ];
  };

  flake.modules.homeManager."desktop.niri" = {
    imports = [
      self.modules.homeManager._default-apps
    ];
    wayland.windowManager.niri.settings = {
    };
  };

  flake.modules.homeManager."desktop.gnome" = {
    imports = [
      self.modules.homeManager._default-apps
    ];
  };

}
