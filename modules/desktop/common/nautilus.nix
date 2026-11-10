{ self, ... }: {

  flake.modules.nixos."desktop.hyprland" = {
    imports = [ self.modules.nixos.nautilus ];
  };

  flake.modules.nixos."desktop.niri" = {
    imports = [ self.modules.nixos.nautilus ];
  };

  flake.modules.nixos."desktop.gnome" = {
    imports = [ self.modules.nixos.nautilus ];
  };

  flake.modules.nixos.nautilus = { pkgs, ... }: {

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };

    services = {
      dbus.packages = [ pkgs.mission-center ];
      gnome = {
        sushi.enable = true;
        gnome-settings-daemon.enable = true;
        glib-networking.enable = true; # 新增：网络挂载
      };
      tumbler.enable = true;
      gvfs.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        turtle
        code-nautilus
        nautilus
        # libadwaita, gsettings-desktop-schemas, glib 可考虑移除
        mission-center
        ffmpegthumbnailer # 新增：视频缩略图
        ffmpeg-headless # 新增：视频缩略图依赖
      ];
      sessionVariables.ADW_DISABLE_PORTAL = 1;
      pathsToLink = [ "share/thumbnailers" ]; # 新增：激活缩略图生成器
    };

  };
}
