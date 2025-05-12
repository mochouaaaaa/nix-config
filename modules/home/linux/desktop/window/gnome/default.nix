{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.gnome;

in
{
  imports = [
    ./config
    ./component
  ];

  options.modules.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "gnome";
      description = "Enable GNOME desktop environment.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xremap.withGnome = lib.mkForce true;

    modules.themes.auto.enable = true;

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
    };

    dconf.settings = {
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.gvariant.mkUint32 250;
        repeat-interval = lib.gvariant.mkUint32 26;
      };
    };

    programs.gnome-shell = {
      enable = true;
    };

  };
}
