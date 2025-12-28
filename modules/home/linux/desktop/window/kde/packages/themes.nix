{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    qt.style.name = "kvantum";

    home.packages = with pkgs; [
      whitesur-kde
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

  };
}
