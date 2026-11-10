{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages =
      with pkgs;
      [
        # insomnia # REST client
        cartero
        # api client
        hoppscotch
        # navicat-premium
        dbeaver-bin
      ]
      ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
        tiny-rdm-wrapper
        # telegram-desktop
        wireshark # network analyzer
        materialgram
      ];
  };
}
