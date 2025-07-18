{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.dm.sddm;
in
{
  options.modules.dm.sddm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the SDDM display manager.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      whitesur-kde
    ];

    services = {
      displayManager = {
        autoLogin = {
          enable = true;
          user = username;
        };
        sddm = {
          enable = true;
          package = lib.mkForce pkgs.kdePackages.sddm;
          # theme = "WhiteSur-dark";
          extraPackages = with pkgs; [
            kdePackages.plasma-desktop
            kdePackages.plasma-workspace
            kdePackages.qtsvg
          ];
          wayland = {
            enable = true;
          };
        };
      };
    };
  };
}
