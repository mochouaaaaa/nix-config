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
        insomnia # REST client
        wireshark # network analyzer

        # api client
        hoppscotch

      ]
      ++ lib.optionals (pkgs.stdenv.isLinux) [
        tiny-rdm-wrapper
        materialgram
        telegram-desktop
      ];
  };
}
