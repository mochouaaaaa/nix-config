{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  gnomeSeries = cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable;
in
{

  config = lib.mkIf gnomeSeries {

    environment.systemPackages = with pkgs; [
      (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))
      turtle # nautilus plugin git operation
      nautilus
      libadwaita
    ];

    security = {
      soteria.enable = true;
      pam = {
        services = {
          greetd.enableGnomeKeyring = true;
          swaylock = { };
          hyprlock = { };
        };
      };
    };

    programs = {
      seahorse.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

    programs.evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    services.gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
      evolution-data-server.enable = true;
    };

    environment = {
      sessionVariables = {
        GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
          with pkgs;
          [
            evolution-data-server
            libical
            glib.out
            libsoup_3
            json-glib
            gobject-introspection
          ]
        );
      };
      extraInit = ''
        export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      '';
    };

    programs.dconf.profiles = {
      user.databases = [
        {
          settings = {
            "org/gnome/nautilus/preferences" = {
              default-sort-order = "mtime";
              default-sort-in-reverse-order = true;
              default-folder-viewer = "list-view";
            };
          };

          locks = [
            "/org/gnome/nautilus/preferences/default-sort-order"
            "/org/gnome/nautilus/preferences/default-sort-in-reverse-order"
          ];
        }
      ];
    };

  };
}
