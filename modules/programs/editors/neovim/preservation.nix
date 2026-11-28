{
  flake.aspects.editors.provides.neovim.provides.preservation.nixos =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.neovim.enable
          [
            ".local/share/nvim"
            ".local/state/nvim"
            ".local/nvim/catppuccin"
          ];
    };
}
