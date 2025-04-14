{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.themes.auto;
in
{

  options.modules.themes.auto = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable auto-theme based on time and location.";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      whitesur-icon-theme
      (whitesur-gtk-theme.override {
        altVariants = [ "all" ];
        nautilusStyle = "mojave";
        roundedMaxWindow = true;
      })
      whitesur-cursors

      (writeShellScriptBin "switch-theme" ''
        #!/usr/bin/env bash

        theme=$1

        if [[ $theme == "light" ]]; then

          if [[ ! -e $HOME/.cache/switch-theme.light ]]; then
             $HOME/.local/state/home-manager/gcroots/current-home/activate
          fi 

        elif [[ $theme == "dark" ]]; then

          if [[ ! -e $HOME/.cache/switch-theme.dark ]]; then
             $HOME/.local/state/home-manager/gcroots/current-home/specialisation/dark/activate
          fi 

        else
          echo "not fount theme mode"
        fi

        notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_''${theme}.png "switching to ''${theme} mode"

      '')
    ];

    specialisation = {
      demo.configuration = { };
      dark.configuration = {

        # 标记当前应用的是什么主题
        home.file = {
          ".cache/switch-theme.light".enable = lib.mkForce false;
          ".cache/switch-theme.dark" = {
            text = ''dark'';
            enable = lib.mkForce true;
          };
        };

        qt.style.name = lib.mkForce "adwaita-dark";
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = lib.mkForce (lib.gvariant.mkString "prefer-dark");
            gtk-theme = lib.mkForce (lib.gvariant.mkString "Adwaita-dark");
            icon-theme = lib.mkForce (lib.gvariant.mkString "WhiteSur-dark");
            cursor-theme = lib.mkForce (lib.gvariant.mkString "Capitaine Cursors (Nord)");
          };
        };

        gtk = {
          theme = {
            name = lib.mkForce "WhiteSur-dark";
          };
          iconTheme = {
            name = lib.mkForce "WhiteSur-dark";
          };
          cursorTheme = {
            name = lib.mkForce "Capitaine Cursors (Nord)";
          };
        };
      };
    };

    services.darkman = {
      enable = false;
      settings = {
        lat = 39.9042;
        lng = 116.4074;
        usegeoclue = true;
      };
      lightModeScripts = {
        gtk-theme = ''
          switch-theme light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          switch-theme dark
        '';
      };
    };
  };
}
