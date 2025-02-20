{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    insomnia # REST client
    wireshark # network analyzer

    # communication

    # document

    # api client
    hoppscotch
  ];
}
