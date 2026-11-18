{ inputs, ... }: {
  flake.modules.homeManager.appearance =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      options.profiles.fonts = {
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

      config = {
        home.packages =
          (with pkgs; [
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
          ])
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            inputs.apple-emoji-font.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
          ];

        fonts.fontconfig = {
          enable = true;
          antialiasing = true;

          defaultFonts = {
            serif = [
              config.profiles.fonts.default
              config.profiles.fonts.serif
            ];
            sansSerif = [ config.profiles.fonts.sansSerif ];
            monospace = [ config.profiles.fonts.monospace ];
            inherit (config.profiles.fonts) emoji;
          };
        };
      };
    };

  flake.modules.nixos.appearance =
    {
      lib,
      options,
      pkgs,
      username,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          fonts = {
            packages = [
              inputs.apple-emoji-font.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
            ];
            fontDir.enable = true;
            enableDefaultPackages = false;
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
          home-manager.users.${username}.profiles.fonts.default = lib.mkForce "Monaco Fira Nerd";
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
