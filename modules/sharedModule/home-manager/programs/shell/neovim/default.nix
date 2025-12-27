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
    luajit
    luajitPackages.luarocks
  ];

  programs = {
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
      extraPackages = with pkgs; [
        fd
        chafa
        ffmpeg
        ripgrep
        imagemagick
        sqlite
        libgit2
        diff-so-fancy
        ghostscript
        multimarkdown
        icu
        python313Packages.pylatexenc
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
