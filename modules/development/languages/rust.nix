{
  flake.modules.homeManager."development.rust" = { pkgs, config, ... }: {

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.rust
          p.ron
        ]))
      ];
      extraPackages = [ pkgs.bacon ];
    };

    home.packages = [ pkgs.rustup ];
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };

  flake.modules.nixos.preservation =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages;
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.rustup homePackages)
          [
            ".local/share/cargo"
            ".local/share/rustup"
          ];
    };
}
