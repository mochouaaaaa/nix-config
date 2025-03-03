{
  lib,
  pkgs,
  myvars,
  ...
}: {
  imports = [
    # ../dm/greetd.nix
    ../dm/sddm.nix
  ];

  environment.systemPackages = with pkgs; [
    localsend
  ];

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
      plasma6.enable = myvars.desktop.kde;
    };
    fwupd = {
      enable = true;
    };
  };

  programs.xwayland.enable = true;

  qt.platformTheme = "kde";
  i18n.inputMethod.fcitx5.plasma6Support = true;
}
