{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.gnome;

  keymaps = import ./config/keymaps.nix;
  plugins-config = import ./config/plugins-config.nix { inherit lib; };
  extensions = import ./config/plugins.nix { inherit pkgs lib; };
  fonts = import ./config/fonts.nix { inherit pkgs; };
in
{
  imports = [
    ./config
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

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
    };

    xdg.configFile."autostart/albert.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Albert
      Comment=Quick launcher with custom parameters
      Exec=albert --platform xcb --platformtheme gnome
      StartupNotify=false
    '';

    dconf.settings = { } // keymaps // plugins-config // fonts.fontConfig;

    programs.gnome-shell = {
      enable = true;
      extensions = extensions.extensions;
    };
  };
}
