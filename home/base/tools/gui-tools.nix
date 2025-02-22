{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    insomnia # REST client
    wireshark # network analyzer

    # api client
    hoppscotch
  ];
}
