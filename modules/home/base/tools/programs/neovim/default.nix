{
  inputs,
  pkgs,
  lib,
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
    ./plugins
  ];

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
      ];
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    zsh.initExtra = lib.optionalString (direnv.enable) ''
      if (( $+commands[direnv] )) &>/dev/null; then
          eval "$(direnv hook zsh)"
          nixify() {
            if [ ! -e ./.envrc ]; then
              echo "use nix" > .envrc
              direnv allow
            fi
            if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
              cat > default.nix <<'EOF'
      with import <nixpkgs> {};
      mkShell {
        nativeBuildInputs = [
          bashInteractive
        ];
      }
      EOF
          ''${EDITOR:-vim} default.nix
            fi
          }
          flakify() {
            if [ ! -e flake.nix ]; then
              nix flake new -t github:nix-community/nix-direnv .
            elif [ ! -e .envrc ]; then
              echo "use flake" > .envrc
              direnv allow
            fi
            ''${EDITOR:-vim} flake.nix
          }
      fi
    '';
  };

  home.sessionVariables = {
    NVIM_IS_NIX = 1;
  };

  xdg.configFile = {
    "rules" = {
      force = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/rules";
    };
  } // config.dotfileLink "nvim";
}
