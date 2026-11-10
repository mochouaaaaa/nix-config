{
  flake.modules.homeManager."desktop.shell.noctalia" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      profiles.rime.themes = {
        dark = "noctalia";
        light = "noctalia";
      };

      programs.vscode.profiles.default = {
        userSettings = {
          "workbench.preferredLightColorTheme" = lib.mkForce "NoctaliaTheme";
        };
        extensions =
          let
            inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
          in
          [
            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "noctaliatheme";
                publisher = "Noctalia";
                version = "0.0.5";
                hash = "sha256-aTSk3yYkBw5GrD0CbRL2wo3SlBffzBTDe1pZoZa1URQ=";
              };
            })
          ];
      };

      programs.yazi.theme = {
        flavor = {
          dark = "noctalia";
          light = "noctalia";
        };
      };

      programs.vicinae = {
        settings = {
          theme = {
            light = {
              name = lib.mkForce "noctalia";
            };
            dark = {
              name = lib.mkForce "noctalia";
            };
          };
          launcher_window = {
            opacity = lib.mkForce 0.68;
          };
        };
      };

      profiles.terminal.kitty.extraConfig = lib.mkAfter [
        "include themes/noctalia.conf"
      ];

      programs.helix.settings = {
        theme = "noctalia";
      };

      programs.zed-editor.userSettings = {
        theme = {
          light = "Noctalia Light";
          dark = "Noctalia Dark";
        };
      };

      programs.emacs.extraConfig = lib.optionalString (config.programs.emacs.enable) ''
        (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
        (load-theme 'noctalia t)
      '';

      # xdg = {
      # dataFile = {
      #   "fcitx5/themes/Matugen" =
      #     let
      #       fictx5-matugen = pkgs.stdenv.mkDerivation {
      #         name = "fcitx5-matugen-theme";
      #
      #         src = pkgs.fetchFromGitHub {
      #           owner = "StatIndet";
      #           repo = "fcitx5-matugen-theme";
      #           rev = "main";
      #           sha256 = "sha256-1tbzTtYqJyDGu5Yyc+QxgqBRm3HWnDucHUuPaeMVk+M=";
      #         };
      #
      #         unpackPhase = false;
      #
      #         installPhase = ''
      #           mkdir -p $out/share/fcitx5/themes
      #           cp -r $src/templates $out/share/fcitx5/themes
      #         '';
      #       };
      #     in
      #     {
      #       source = "${fictx5-matugen}/share/fcitx5/themes";
      #       recursive = true;
      #     };
      # };
      # configFile = {
      #   "noctalia/templates.toml".source =
      #     let
      #       settingsFormat = pkgs.formats.toml { };
      #
      #       settings = {
      #         theme = {
      #           templates = {
      #             enable_builtin_templates = true;
      #             enable_community_templates = true;
      #
      #             user =
      #               let
      #                 fcitx5-theme = "~/.local/share/fcitx5/themes/Matugen";
      #               in
      #               {
      #                 fcitx5_theme = {
      #                   input_path = "${fcitx5-theme}/templates/theme.conf";
      #                   output_path = "${fcitx5-theme}/theme.conf";
      #                   index = 10;
      #                 };
      #                 fcitx5_panel = {
      #                   input_path = "${fcitx5-theme}/templates/panel.svg";
      #                   output_path = "${fcitx5-theme}/panel.svg";
      #                   index = 20;
      #                 };
      #                 fcitx5_highlight = {
      #                   input_path = "${fcitx5-theme}/templates/highlight.svg";
      #                   output_path = "${fcitx5-theme}/highlight.svg";
      #                   index = 30;
      #                 };
      #                 fcitx5_radio = {
      #                   input_path = "${fcitx5-theme}/templates/radio.svg";
      #                   output_path = "${fcitx5-theme}/radio.svg";
      #                   index = 40;
      #                 };
      #                 fcitx5_arrow = {
      #                   input_path = "${fcitx5-theme}/templates/arrow.svg";
      #                   output_path = "${fcitx5-theme}/arrow.svg";
      #                   index = 50;
      #                   post_hook = "busctl --user call org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1 ReloadAddonConfig s classicui";
      #                 };
      #               };
      #
      #           };
      #         };
      #       };
      #     in
      #     settingsFormat.generate "templates.toml" settings;
      # };
      # };

      programs.noctalia = {
        settings = {
          theme = {
            custom_palette = "summer-scene-light-fs";
            mode = "auto";
            pure_black_dark = false;
            source = "wallpaper";
            wallpaper_scheme = "m3-fruit-salad";
            enable_community_templates = true;
            templates = {
              builtin_ids = [
                "alacritty"
                "btop"
                "cava"
                "gtk3"
                "gtk4"
                "kcolorscheme"
                "kitty"
                "qt"
                "wezterm"
              ];
              community_ids = [
                "feishin"
                "spicetify"
                "chromium-based"
                "pywalfox"
                "zen-browser"
                "discord"
                "telegram"
                "obsidian"
                "vscode"
                "zed"
                "steam"
                "vicinae"
                "obs"
                "fcitx5"
                "bat"
                "fzf"
                "lazygit"
                "yazi"
              ];
            };
          };
        };
      };
    };
}
