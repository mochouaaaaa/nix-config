{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  imports = self.mylib.scanPaths ./.;

  options.modules.desktop.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "niri";
      description = "Enable Niri window manager";
    };
  };

  config = lib.mkIf cfg.enable {

    services.xremap.withWlroots = lib.mkForce true;

    # auto dark/light theme
    modules.themes.auto.enable = true;

    modules.desktop = {
      component = {
        waybar.enable = true;
        rofi.enable = true;
        wlogout.enable = true;
        swaync.enable = true;
        swaylock.enable = true;
      };
    };

    modules.packages.vscode.commandLineArgs = lib.mkAfter [
      "--gtk-version=4"
      "--ozone-platform-hint=auto"
      "--password-store=gnome"
    ];
  };
}
