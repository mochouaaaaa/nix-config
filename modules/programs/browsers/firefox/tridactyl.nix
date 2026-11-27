{
  flake.aspects."desktop.programs".provides.browsers.firefox."homeManager" =
    { pkgs, ... }:
    {
      programs.firefox = {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
      };

      xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
    };
}
