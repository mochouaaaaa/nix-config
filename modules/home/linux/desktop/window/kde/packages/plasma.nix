{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;
      overrideConfig = true;
      configFile = {
        kdeglobals.General = {
          TerminalApplication = "kitty";
          TerminalService = "kitty.desktop";
        };
        kcminputrc.Mouse = {
          X11LibInputXAccelProfileFlat = true;
          cursorSize = 36;
        };
        kwinrc.Wayland."InputMethod" = {
          value = "$HOME/.nix-profile/share/applications/fcitx5-wayland-launcher.desktop";
          shellExpand = true;
        };
      };
    };
  };
}
