{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  imports = [
    inputs.hyprlux.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.hyprlux = {
      enable = false;

      systemd = {
        enable = true;
        # target = "wayland-session@Hyprland.target";
        target = "hyprland-session.target";
      };

      night_light = {
        enabled = true;
        latitude = 39.9042;
        longitude = 116.4074;

        start_time = "23:00"; # 21:00 开启夜间模式
        end_time = "06:30"; # 06:30 关闭夜间模式

        # 色温（暖色更护眼，默认 3500K）
        temperature = 3000;
      };
    };
  };
}
