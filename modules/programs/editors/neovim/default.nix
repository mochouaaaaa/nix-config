{ self, ... }:
{
  flake.modules.homeManager."cli.neovim" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      toLus = lib.generators.toLua { };
      isNixDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
    in
    {
      imports = [
        self.modules.homeManager."cli.neovim.plugins"
        self.modules.homeManager."cli.neovim.lsp"
        self.modules.homeManager."cli.neovim.tooling"
      ];

      programs.neovim = {
        enable = true;
        package = pkgs.neovim-unwrapped;
        defaultEditor = true;

        initLua = ''
          vim.g.IS_NIX      = true
          vim.g.is_linux    = ${toLus isLinux}
          vim.g.is_darwin   = ${toLus isNixDarwin}

          -- bootstrap lazy.nvim, LazyVim and your plugins
          require("config.lazy")
        '';
        extraWrapperArgs = with pkgs; [
          "--prefix"
          "LD_LIBRARY_PATH"
          ":"
          (lib.makeLibraryPath [
            stdenv.cc.cc
            zlib
            sqlite
            openssl
          ])
        ];
        extraLuaPackages = ps: [
          ps.magick
          ps.luarocks
          ps.luacheck
          ps.jsregexp
          ps.nvim-web-devicons
        ];
        extraPackages = with pkgs; [
          fzf
          viu
          ast-grep
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
          prettier
          tree-sitter
        ];
        withRuby = false;
      };

      xdg.configFile = config.profiles.dotfileLink "nvim";
    };
}
