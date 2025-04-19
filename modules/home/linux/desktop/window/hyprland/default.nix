{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
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
    enable = lib.mkOption {
      default = builtins.getEnv "DESKTOP" == "hyprland";
      type = lib.types.bool;
      description = "Enable Hyprland desktop environment.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {

      services.xremap.withWlroots = lib.mkForce true;

      # auto dark/light theme
      modules.themes.auto.enable = true;

      modules.desktop.component = {
        waybar.enable = true;
        rofi.enable = true;
        wlogout.enable = true;
        swaync.enable = true;
        swaylock.enable = false;
      };
    })
  ];
}
