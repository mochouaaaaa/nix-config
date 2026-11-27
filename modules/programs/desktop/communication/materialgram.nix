{
  flake.aspects."desktop.programs.communication"."homeManager" = { pkgs, ... }: {
    home.packages = [
      pkgs.materialgram
    ];
  };

  flake.aspects."preservation"."nixos" =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.materialgram homePackages)
          [
            ".local/share/materialgram"
            ".local/share/TelegramDesktop"
          ];
    };

}
