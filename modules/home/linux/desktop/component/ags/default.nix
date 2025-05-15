{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.component.ags;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  options.modules.desktop.component.ags = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable AGS (Adventure Game Studio) component.";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.notifd
      inputs.ags.packages.${pkgs.system}.mpris
      inputs.ags.packages.${pkgs.system}.auth
      material-symbols
      wl-screenrec
    ];

    programs.ags = {
      enable = true;
      extraPackages = [
        pkgs.libsoup_3
        pkgs.gtksourceview
        pkgs.libnotify
        pkgs.webkitgtk_4_1
        pkgs.gst_all_1.gstreamer
        inputs.ags.packages.${pkgs.system}.apps
        inputs.ags.packages.${pkgs.system}.battery
        inputs.ags.packages.${pkgs.system}.hyprland
        inputs.ags.packages.${pkgs.system}.wireplumber
        inputs.ags.packages.${pkgs.system}.network
        inputs.ags.packages.${pkgs.system}.tray
        inputs.ags.packages.${pkgs.system}.notifd
        inputs.ags.packages.${pkgs.system}.mpris
        inputs.ags.packages.${pkgs.system}.bluetooth
        inputs.ags.packages.${pkgs.system}.auth
        inputs.ags.packages.${pkgs.system}.powerprofiles
      ];
    };

  };
}
