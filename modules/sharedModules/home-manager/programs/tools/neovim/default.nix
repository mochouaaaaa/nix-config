{
  pkgs,
  config,
  inputs,
  ...
}:
{

  imports = [ inputs.nixvim.homeModules.nixvim ];

  home.packages = with pkgs; [
    luajit
    luajitPackages.luarocks
  ];

  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.pkgs = pkgs;
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
        ps.jsregexp
      ];
      extraPackages = with pkgs; [
        fzf
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
        lua51Packages.lua
        lua51Packages.luarocks
      ];
      extraPython3Packages = ps: [
        ps.pynvim
      ];
      withNodeJs = true;
    };
  };

  xdg.configFile = config.profiles.dotfileLink "nvim";
}
