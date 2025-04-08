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
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
  ];

  programs = rec {
    neovim = {
      enable = true;
      # package = inputs.neovim.packages.${pkgs.system}.default;
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
    "nvim" = {
      force = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/nvim";
    };
    "rules" = {
      force = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/rules";
    };
  };
}
