{

  flake.modules.homeManager."desktop.common" = { self, ... }: {
    imports = [
      self.modules.homeManager."development.rust"
    ];
  };

  flake.modules.homeManager."development.rust" = { pkgs, config, ... }: {

    home.packages = [
      pkgs.rustup
    ];

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };

  };

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".local/share/cargo"
      ".local/share/rustup"
    ];
  };

}
