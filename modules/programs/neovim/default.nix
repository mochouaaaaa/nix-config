{ self, ... }: {

  flake.modules.homeManager."desktop.common" = {
    imports = [ self.modules.homeManager."programs.neovim" ];
  };

  flake.modules.homeManager."programs.neovim" =
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
      programs = {
        neovim = {
          enable = true;
          package = pkgs.neovim-unwrapped;
          defaultEditor = true;
          initLua = ''
            vim.g.is_linux    = ${toLus isLinux}
            vim.g.is_darwin   = ${toLus isNixDarwin}

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
          withPython3 = true;
          withRuby = false;
          withNodeJs = true;
        };
      };

      xdg.configFile = config.profiles.dotfileLink "nvim";
    };

}
