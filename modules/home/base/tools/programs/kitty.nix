{
  lib,
  config,
  ...
}: let
  cfgDesktop = config.modules.desktop;
  cfgKitty = config.modules.packages.kitty;
in {
  options.modules.packages.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the kitty terminal emulator.";
    };
  };

  config = lib.mkIf cfgKitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      extraConfig = lib.mkIf cfgDesktop.kde.enable ''
        hide_window_decorations yes
        background_opacity 1.0
      '';
    };

    xdg.configFile = {
      "kitty/kitty.conf".enable = false;
      "kitty" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/kitty";
      };
    };
  };
}
