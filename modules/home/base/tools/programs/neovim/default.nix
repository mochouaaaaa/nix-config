{
  pkgs,
  lib,
  config,
  self,
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

  imports = self.importModule' ./.;

  programs = rec {
    neovim = {
      enable = true;
      extraLuaConfig = ''
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
      extraPython3Packages = ps: [ ps.debugpy ];
      withNodeJs = true;
      # These environment variables are needed to build and run binaries
      # with external package managers like mason.nvim.
      #
      # LD_LIBRARY_PATH is also needed to run the non-FHS binaries downloaded by mason.nvim.
      # it will be set by nix-ld, so we do not need to set it here again.
      extraWrapperArgs = with pkgs; [
        # LIBRARY_PATH is used by gcc before compilation to search directories
        # containing static and shared libraries that need to be linked to your program.
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [
          stdenv.cc.cc
          zlib
        ]}"

        # PKG_CONFIG_PATH is used by pkg-config before compilation to search directories
        # containing .pc files that describe the libraries that need to be linked to your program.
        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
          stdenv.cc.cc
          zlib
        ]}"
      ];
    };
  };

  home.sessionVariables = {
    NVIM_IS_NIX = 1;
  };

  xdg.configFile = config.dotfileLink "nvim";
}
