{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  config = lib.mkIf (config.programs.desktop.enable) {

    home.packages = with pkgs; [
      flatpak-wrapper
    ];

    services = {
      flatpak = {
        enable = true;
        remotes = lib.mkOptionDefault [
          {
            name = "flathub";
            location = "https://flathub.org/repo/flathub.flatpakrepo";
          }
        ];
        uninstallUnmanaged = false;
        update.auto = {
          enable = false;
        };
        packages = [ "io.github.flattool.Warehouse" ];
      };
    };

  };
}
