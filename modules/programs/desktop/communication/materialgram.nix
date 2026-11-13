{
  flake.modules.homeManager."desktop.programs" = { pkgs, ... }: {
    home.packages = [
      pkgs.materialgram
    ];
  };

  flake.modules.nixos."desktop.common" = { username, ... }: {
    profiles.preservation.users."${username}".directories = [
      ".local/share/materialgram"
      ".local/share/TelegramDesktop"
    ];
  };

}
