{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgKde = config.modules.desktop.kde;
in
{
  options.modules.desktop = {
    kde = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = builtins.getEnv "DESKTOP" == "kde";
        description = "Enable KDE desktop environment.";
      };
    };
  };

  config = lib.mkIf cfgKde.enable {

    # modules.dm.sddm.enable = true;
    modules.dm.greetd.enable = true;

    services = {
      xserver = {
        enable = true;
      };
      greetd = {
        settings = {
          default_session = {
            command = lib.mkForce "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
          };
        };
      };
      desktopManager = {
        plasma6.enable = true;
      };
      fwupd = {
        enable = true;
      };
    };

    programs.xwayland.enable = true;

    qt = {
      platformTheme = "kde";
      style = "kvantum";
    };
    i18n.inputMethod.fcitx5.plasma6Support = true;
  };
}
