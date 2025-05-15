{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    programs = {
      # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
      # google-chrome = {
      chromium = {

        nativeMessagingHosts = [
          pkgs.kdePackages.plasma-browser-integration
        ];
      };
    };

  };
}
