{
  flake.aspects."desktop.programs.browsers"."homeManager" =
    { pkgs, ... }:
    {
      programs.firefox = {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
      };

      xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
    };
}
