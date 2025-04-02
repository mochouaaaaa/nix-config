{
  inputs,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard
    # tectonic-unwrapped
    ghostscript
    multimarkdown
    icu
    python313Packages.pylatexenc
  ];

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
  ];

  programs = {
    neovim = {
      enable = true;
      # package = inputs.neovim.packages.${pkgs.system}.default;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [
        pkgs.imagemagick
        pkgs.sqlite
      ];
      withNodeJs = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };

  home.sessionVariables = {
    NVIM_IS_NIX = 1;
  };

  xdg.configFile = {
    "nvim/init.lua".enable = false;
    "nvim" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/nvim";
    };
    "rules" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/rules";
    };
  };
}
