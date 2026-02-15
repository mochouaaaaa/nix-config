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
        # api client
        hoppscotch
        materialgram
      ]
      ++ lib.optionals (pkgs.stdenv.isLinux) [
        tiny-rdm-wrapper
        telegram-desktop
        wireshark # network analyzer
      ];
  };
}
