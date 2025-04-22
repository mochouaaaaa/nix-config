{
  self,
  pkgs,
  ...
}:
{
  imports = self.mylib.scanPaths ./.;

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # 让 Electron 应用使用 Wayland
  };

  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
}
