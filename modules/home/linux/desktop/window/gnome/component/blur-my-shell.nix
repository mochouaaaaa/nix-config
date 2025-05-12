{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.gnome.shell.packages.blur-my-shell;
in
{

  options.modules.desktop.gnome.shell.packages.blur-my-shell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable blur-my-shell extension.";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.blur-my-shell; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/blur-my-shell" = {
        settings-version = lib.hm.gvariant.mkInt32 2;
      };
      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = lib.hm.gvariant.mkDouble 0.6;
        sigma = 60;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = false;
      };
      "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
        pipeline = "pipeline_default";
      };
      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = false;
      };
      "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
        blur-original-panel = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
        pipeline = "pipeline_default";
        compatibility = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline = "pipeline_default";
      };
      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        pipeline = "pipeline_default";
        style-components = 3;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = true;
        force-light-text = true;
        brightness = lib.hm.gvariant.mkDouble 0.6;
        override-background = true;
        override-background-dynamically = true;
        pipeline = "pipeline_default";
        sigma = 60;
      };
      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        pipeline = "pipeline_default";
      };
    };
  };
}
