{ config, lib, ... }:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      shortcuts = {
        ksmserver = {
          "Halt Without Confirmation" = "none";
          "Lock Session" = [
            "Screensaver"
            "Meta+Ctrl+Q"
          ];
          "Log Out" = "Meta+Ctrl+Del";
          "Log Out Without Confirmation" = "none";
          "LogOut" = "none";
          "Reboot" = "none";
          "Reboot Without Confirmation" = "none";
          "Shut Down" = "none";
          "_k_friendly_name" = "Session Management";
        };
      };
    };
  };
}
