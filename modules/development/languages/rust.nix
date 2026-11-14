{
  flake.modules.homeManager.development = { self, ... }: {
    imports = [ self.modules.homeManager."development.rust" ];
  };
  flake.modules.homeManager."development.rust" = { pkgs, config, ... }: {
    home.packages = [ pkgs.rustup ];
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };
  flake.modules.nixos.preservation = { lib, pkgs, config, username, ... }:
    let homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.rustup homePackages) [ ".local/share/cargo" ".local/share/rustup" ];
    };
}
