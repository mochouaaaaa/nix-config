{
  flake.modules.homeManager.development = { pkgs, config, ... }: {

    home.packages = [
      pkgs.rustup
    ];

    programs.zsh.envExtra = ''
      export CARGO_HOME="${config.xdg.dataHome}/cargo"
      export RUSTUP_HOME="${config.xdg.dataHome}/rustup"
    '';

    programs = {
      cargo = {
        enable = false;
      };
    };

  };

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".local/share/cargo"
      ".local/share/rustup"
    ];
  };

}
