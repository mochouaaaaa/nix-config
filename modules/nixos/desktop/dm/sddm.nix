{
  self,
  pkgs,
  config,
  lib,
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
        sddm = {
          enable = true;
          package = lib.mkForce pkgs.kdePackages.sddm;
          settings = {
            Autologin = {
              User = "${self.myvars.username}";
            };
          };
          theme = "WhiteSur-dark";
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
