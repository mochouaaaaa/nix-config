{
  flake.aspects."desktop.programs".provides.communication.discord.homeManager = { pkgs, ... }: {

    programs.discord = {
      enable = true;
      package = pkgs.vencord;
    };

    programs.vesktop.enable = true;

  };

  flake.aspects.preservation.nixos =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.vesktop.enable
          [
            ".config/vesktop"
          ];
    };

}
