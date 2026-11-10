{
  flake.modules.homeManager."desktop.common" = { pkgs, ... }: {

    home.packages = with pkgs; [
      splayer-next
    ];

  };

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".config/SPlayer"
    ];
  };

}
