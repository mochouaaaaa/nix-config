{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktop.hyprland;
in {
  imports = [
    ./packages.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprlux.nix
    ./xdg.nix
    ./xdph.nix
    ../../component
    ./scripts
  ];

  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment" // {default = false;};
    uwsm = lib.mkEnableOption "UWSM status manager" // {default = false;};
  };

  config = lib.mkMerge [
    (
      lib.mkIf cfg.enable {
        modules.desktop.component = {
          waybar.enable = true;
          rofi.enable = true;
          wlogout.enable = true;
          swaync.enable = true;
          swaylock.enable = false;
        };
      }
    )
  ];
}
