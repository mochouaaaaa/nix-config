{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{

  imports = lib.importModule' ./. ++ [ inputs.nixvim.homeModules.nixvim ];

  home.packages = with pkgs; [
    wl-clipboard
    # tectonic-unwrapped
    ghostscript
    multimarkdown
    icu
    python313Packages.pylatexenc
  ];

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
        ps.luarocks
        ps.luacheck
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

  xdg.configFile = config.modules'.dotfileLink "nvim";
}
