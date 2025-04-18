{
  config,
  pkgs,
  lib,
  pkgs-stable,
  pkgs-unstable,
  ...
}:
let
  cfg = config.modules.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs-unstable.albert
      gnome-tweaks
      dconf-editor
    ];

    xdg.configFile = {
      "albert/config" = {
        text = ''
          [General]
          telemetry=true

          [applications]
          enabled=true
          terminal=kitty

          [clipboard]
          enabled=true
          persistent=true

          [websearch]
          enabled=true

          [widgetsboxmodel]
          alwaysOnTop=true
          clearOnHide=true
          clientShadow=true
          displayScrollbar=false
          followCursor=true
          hideOnFocusLoss=true
          historySearch=true
          itemCount=5
          quitOnClose=false
          showCentered=true
          systemShadow=true
        '';
        force = true;
      };
    };
  };
}
