{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      insomnia # REST client
      wireshark # network analyzer

      # api client
      hoppscotch

      materialgram
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      tiny-rdm-wrapper
    ];
}
