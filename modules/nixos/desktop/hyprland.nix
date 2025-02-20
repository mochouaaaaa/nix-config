{
  lib,
  pkgs,
  myvars,
  ...
}: {
  programs.hyprland = {
    enable = myvars.desktop.hyprland;
    systemd.setPath.enable = true;
  };
  programs.uwsm = {
    enable = false;
    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = lib.mkForce "${lib.getExe pkgs.hyprland}";
    };
    waylandCompositors.waybar = {
      prettyName = "Waybar";
      comment = "Waybar compositor managed by UWSM";
      binPath = lib.mkForce "${lib.getExe pkgs.waybar}";
    };
  };
}
