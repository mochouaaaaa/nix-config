{
  flake.modules.homeManager.programs =
    { pkgs, ... }:
    {
      programs.firefox = {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
      };

      xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
    };
}
