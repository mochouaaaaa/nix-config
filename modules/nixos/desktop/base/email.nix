{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop;
  gnomeSeries = cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable;
in
{
  config = lib.mkIf gnomeSeries {

    programs.evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    services.gnome.evolution-data-server.enable = true;

    environment.systemPackages = with pkgs; [
      (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))
    ];

    environment.sessionVariables = {
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

  };
}
