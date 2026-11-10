{
  flake.modules.homeManager."desktop.gui-tools" = { pkgs, ... }: {
    home.packages = [
      pkgs.materialgram
    ];
  };

  flake.modules.nixos."desktop.common" = { self, username, ... }: {
    home-manager.users.${username}.imports = [
      self.modules.homeManager."desktop.gui-tools"
    ];

    profiles.preservation.users."${username}".directories = [
      ".local/share/materialgram"
      ".local/share/TelegramDesktop"
    ];
  };

}
