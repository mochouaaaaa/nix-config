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
      (flatpak.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postFixup = (oldAttrs.postFixup or "") + ''
          wrapProgram $out/bin/flatpak \
            --prefix XDG_DATA_DIRS : /var/lib/flatpak/exports/share:${config.home.homeDirectory}/.local/share/flatpak/exports/share
        '';
      }))

    ];

    services = {
      flatpak = {
        overrides = {
          global = { };
        };
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
        packages = [
          "io.github.flattool.Warehouse"
        ];
      };
    };

  };
}
