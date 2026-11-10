{ inputs, ... }: {
  flake.modules.homeManager.appearance =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.profiles.fonts;
    in
    {

      options.profiles.fonts = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable font configuration.";
        };
        default = lib.mkOption {
          type = lib.types.str;
          default = "Monaco Nerd Font";
        };
        serif = lib.mkOption {
          type = lib.types.str;
          default = "Source Han Serif";
        };
        sansSerif = lib.mkOption {
          type = lib.types.str;
          default = "Source Han Sans";
        };
        monospace = lib.mkOption {
          type = lib.types.str;
          default = "Maple Mono CN";
        };
        emoji = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "Apple Color Emoji"
            "Symbols Nerd Font"
            "Noto Color Emoji"
          ];
        };
      };

      config = lib.mkMerge [
        {
          home.packages = with pkgs; [
            inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.fonts.monaco
            maple-mono.opentype
            inter

            # Icon fonts
            fira-code
            nerd-fonts.symbols-only

            # General purpose fonts from former os/fonts.nix
            noto-fonts
            noto-fonts-cjk-sans
            source-sans
            source-serif
            source-han-sans
            source-han-serif
          ];

          fonts.fontconfig = lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) {
            defaultFonts = {
              serif = [
                cfg.default
                cfg.serif
              ];
              sansSerif = [ cfg.sansSerif ];
              monospace = [ cfg.monospace ];
              emoji = cfg.emoji;
            };
          };
        }
        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          home.packages = [
            inputs.apple-emoji-font.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
          ];
          fonts.fontconfig = {
            enable = true;
            antialiasing = true;
          };
          # xdg.dataFile = {
          #   "fonts".source = "/run/current-system/sw/share/X11/fonts";
          # };
        })

      ];

    };

  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      options,
      ...
    }:
    {

      config = lib.mkMerge [
        {
          fonts = {
            fontDir.enable = true;
            enableDefaultPackages = false;
            packages = [
              inputs.apple-emoji-font.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
            ];
            fontconfig = {
              useEmbeddedBitmaps = true;
              defaultFonts = {
                serif = [
                  "Monaco Nerd Font"
                  "Source Han Serif"
                ];
                sansSerif = [ "Source Han Sans" ];
                monospace = [ "Maple Mono CN" ];
                emoji = [
                  "Apple Color Emoji"
                  "Symbols Nerd Font"
                  "Noto Color Emoji"
                ];
              };
            };
          };
        }
        (lib.mkIf (options ? home-manager) {
          home-manager.sharedModules = [
            {
              profiles.fonts = {
                enable = lib.mkForce false;
                default = lib.mkForce "Monaco Fira Nerd";
              };
            }
          ];
        })
      ];

    };

  flake.modules.darwin.default = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.fonts.monaco
      maple-mono.CN

      # UI
      inter

      # Icon fonts
      nerd-fonts.symbols-only

      # General purpose fonts from former os/fonts.nix
      fira-code
      noto-fonts
      noto-fonts-cjk-sans
      source-sans
      source-serif
      source-han-sans
      source-han-serif
    ];
  };
}
