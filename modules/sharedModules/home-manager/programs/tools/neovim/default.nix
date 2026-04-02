{
  lib,
  pkgs,
  config,
  isNixos ? false,
  isNixDarwin ? false,
  ...
}:
{

  home.packages = with pkgs; [
    luajit
    luajitPackages.luarocks
  ];

  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      defaultEditor = true;
      initLua =
        let
          toLus = lib.generators.toLua { };
        in
        ''
          vim.g.IS_NIX      = true
          vim.g.is_nixos    = ${toLus isNixos}
          vim.g.is_dariwn   = ${toLus isNixDarwin}

          -- bootstrap lazy.nvim, LazyVim and your plugins
          require("config.lazy")
        '';
      extraWrapperArgs = with pkgs; [
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [
          stdenv.cc.cc
          zlib
          sqlite
        ]}"
        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
          stdenv.cc.cc
          zlib
        ]}"
      ];
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
        mermaid-cli
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
