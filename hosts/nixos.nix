{ self, inputs, ... }:
let
  homeModules = [
    self.homeModules.linux

    {
      profiles = {
        languages = {
          envs = {
            python.enable = true;
            goenv.enable = true;
            node.enable = true;
            rust.enable = true;
          };
        };
        packages = {
          ollama.enable = true;
          firefox.enable = true;
          google-chrome.enable = true;

          # tencent enable default use true
          tencent = {
            # qq.enable = false;
            wechat.enable = true;
            wemeet.enable = true;
            dingding.enable = true;
            feishu.enable = true;
          };

          obsidian.enable = false;
          live = {
            simple-live-app.enable = true;
            wiliwili.enable = true;
            iptv.enable = true; # IPTV
          };

          # defalut enable true
          bitwarden.enable = true;
          authenticator.enable = true;

          terminal = {
            kitty.enable = true;
            wezterm.enable = false;
          };

          jetbrains = {
            enable = true;
            pycharm.enable = true;
            goland.enable = true;
            datagrip.enable = true;
            clion.enable = true;
          };
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
          (inputs.import-tree ./nixos)
        ]
        ++ [
          self.nixosModules.base
          self.nixosModules.services
          self.nixosModules.virtual
          self.nixosModules.desktop

          {
            profiles = {
              i18n.locale = "en_US";
              network.proxy.sparkle.enable = true;
              virtual = {
                virtualbox.enable = false;
                vmware.enable = false;
                qemu.enable = true;
                docker.enable = true;
              };
              services = {
                database-suite.enable = false;
              };
              packages = {
                steam = {
                  enable = true;
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
