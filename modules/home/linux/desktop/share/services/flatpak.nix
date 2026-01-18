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

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages = with pkgs; [
      flatpak
    ];

    xdg.systemDirs.data = [
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    ];

    services = {
      flatpak = {
        enable = true;
        overrides = {
          global = {
            Context = {
              filesystems = [
                "/etc/fonts:ro"
              ];
            };
            Environment = {
              GTK_THEME = "Adwaita";
            };
          };
        };
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
        packages = [
          "io.github.flattool.Warehouse"
        ];
      };
    };

  };
}
