{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.dm.sddm;
in {
  options.modules.dm.sddm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the SDDM display manager.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (sddm-astronaut.override {
        embeddedTheme = "Pixel sakura static";
      })
    ];
    services = {
      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = true;
          wayland.enable = true;
        };
      };
    };
  };
}
