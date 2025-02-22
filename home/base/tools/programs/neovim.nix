{
  pkgs,
  myvars,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    tectonic
    ghostscript
    multimarkdown
    icu
  ];
  programs = {
    neovim = {
      enable = myvars.packages.neovim;
      extraLuaPackages = ps: [ps.magick];
      extraPackages = [pkgs.imagemagick pkgs.sqlite];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
