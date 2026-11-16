{
  flake.modules.homeManager."desktop.programs.communication" = { pkgs, ... }: {

    programs.discord = {
      enable = true;
      package = pkgs.vencord;
    };

    programs.vesktop.enable = true;

  };

  flake.modules.nixos.preservation =
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
