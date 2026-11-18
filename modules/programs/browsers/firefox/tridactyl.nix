{
  flake.modules.homeManager."desktop.programs.browsers" =
    { pkgs, ... }:
    {
      programs.firefox = {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
      };

      xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
    };
}
