{
  pkgs,
  lib,
  config,
  inputs,
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

  imports = lib.importModule' ./. ++ [ inputs.nixvim.homeModules.nixvim ];

  programs = rec {
    nixvim = {
      enable = true;
      defaultEditor = true;
      globals = {
        IS_NIX = true;
      };
      extraConfigLuaPre = ''
        -- bootstrap lazy.nvim, LazyVim and your plugins
        require("config.lazy")
      '';
      extraLuaPackages = ps: [
        ps.magick
        pkgs.luajitPackages.luarocks
        pkgs.luajitPackages.luacheck
      ];
      extraPackages = [
        pkgs.imagemagick
        pkgs.sqlite
        pkgs.libgit2
      ];
      extraPython3Packages = ps: [
        ps.debugpy
        ps.pynvim
      ];
      withNodeJs = true;
    };
  };

  xdg.configFile = config.dotfileLink "nvim";
}
