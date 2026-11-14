{
  flake.modules.homeManager."desktop.programs.media" = { pkgs, ... }: {

    home.packages = with pkgs; [
      splayer-next
    ];

  };

  flake.modules.nixos.preservation =
    { lib, pkgs, config, username, ... }:
    let homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.splayer-next homePackages) [ ".config/SPlayer" ];
    };

}
