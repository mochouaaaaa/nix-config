{
  flake.aspects."desktop.programs.media"."homeManager" = { pkgs, ... }: {

    home.packages = with pkgs; [
      # splayer-next
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
        lib.optionals (lib.elem pkgs.splayer-next homePackages)
          [ ".config/SPlayer" ];
    };

}
