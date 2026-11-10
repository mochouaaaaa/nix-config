{
  flake.modules.homeManager."programs.flatpak" =
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
                  "xdg-config/gtk-3.0:ro"
                  "xdg-config/gtk-4.0:ro"
                  "/nix/store:ro"
                  "${config.home.homeDirectory}/.icons:ro"
                  "${config.home.homeDirectory}/.local/share/fonts:ro"
                ];
              };
              Environment = {
                # GTK_THEME = "${config.profiles.themes.gtkTheme.name}";
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
            "com.github.tchx84.Flatseal"
            "io.github.flattool.Warehouse"
          ];
        };
      };

    };

  flake.modules.nixos."desktop.common" =
    {
      self,
      lib,
      config,
      username,
      ...
    }:
    {
      home-manager.users.${username}.imports = [
        self.modules.homeManager."programs.flatpak"
      ];

      profiles.preservation =
        lib.optionalAttrs (config.home-manager.users.${username}.services.flatpak.enable)
          {
            users.${username}.directories = [
              ".local/share/containers"
              ".local/share/flatpak"
              ".var/app"
            ];
            directories = [
              "/var/lib/flatpak"
            ];
          };

    };

}
