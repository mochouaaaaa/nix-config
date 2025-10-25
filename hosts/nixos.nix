{ self, ... }:
let
  homeModules = [
    self.homeModules.linux.modules

    {
      modules'.packages = {
        firefox.enable = true;
        google-chrome.enable = true;

        translate.enable = true;
        # tencent enable default use true
        tencent = {
          # qq.enable = false;
          # wechat.enable = false;
          # wemeet.enable = false;
          # dingding.enable = false;
          # feishu.enable = false;
        };

        obsidian.enable = true;
        live = {
          simple-live-app.enable = true;
          wiliwili.enable = true;
          hypontix.enable = false; # IPTV
        };

        # defalut enable true
        bitwarden.enable = true;
        authenticator.enable = true;

        terminal = {
          kitty.enable = true;
          wezterm.enable = true;
        };

        jetbrains = {
          enable = true;
          pycharm.enable = true;
          goland.enable = true;
          datagrip.enable = true;
          clion.enable = true;
        };
        envs = {
          pyenv.enable = true;
          goenv.enable = true;
          nodenv.enable = false;
          luaenv.enable = true;
        };
      };
    }
  ];

in
{

  flake-parts = {
    nixosConfigurations = {
      "mochou@nixos" = {
        system = "x86_64-linux";
        stateVersion = "25.05";
        modules = [
          ./nixos/default.nix

          self.nixosModules.base
          self.nixosModules.services
          self.nixosModules.virtual
          self.nixosModules.desktop

          {
            modules' = {
              network.proxy.clash-party.enable = true;
              virtual = {
                virtualbox.enable = false;
                vmware.enable = false;
                qemu.enable = false;
              };
              packages = {
                database-suite.enable = true;
                steam = {
                  enable = false;
                  monitor = "DP-1";
                  bg = 892387259;
                };
              };
            };
          }

        ];

        homeModules = homeModules;
      };
    };

    homeConfigurations = {
      "mochou@nixos" = {
        system = "x86_64-linux";
        stateVersion = "24.11";
        modules = homeModules;
      };
    };
  };
}
