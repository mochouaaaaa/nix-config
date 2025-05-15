{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.themes.auto.kdeTheme;
in
{

  options.modules.themes.auto = {
    kdeTheme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable KDE theme.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      (writeShellScriptBin "switch-theme" ''
        theme=$1

        export XDG_CURRENT_DESKTOP=KDE
        export KDE_FULL_SESSION=true

        if [[ -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
          export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
        fi

        if [[ $theme == "light" ]]; then
          lookandfeeltool -a com.github.vinceliuice.WhiteSur-alt
        elif [[ $theme == "dark" ]]; then
          lookandfeeltool -a com.github.vinceliuice.WhiteSur-dark
        fi

      '')
    ];

    services.darkman = {
      lightModeScripts = {
        kde-theme = ''
          switch-theme light
        '';
      };
      darkModeScripts = {
        kde-theme = ''
          switch-theme dark
        '';
      };
    };

  };
}
