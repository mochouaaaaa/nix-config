{ self, inputs, ... }:
{

  flake-parts = {
    nixosConfigurations = {
      nixos = {
        system = "x86_64-linux";
        stateVersion = "24.11";
        modules = [
          ./nixos/default.nix

          self.nixosModules.base
          self.nixosModules.services
          self.nixosModules.virtual

        ];

        nixosDisables = [
          {
            modules = {
              virtual = {
                virtualbox.enable = false;
                vmware.enable = false;
                qemu.enable = false;
              };
            };
          }
        ];
      };
    };

    homeConfigurations = {
      "mochou@nixos" = {
        system = "x86_64-linux";
        stateVersion = "24.11";
        modules = [
          self.homeModules.linux.modules
        ];
        homeDisables = [
          {
            modules.packages = {
              # tencent enable default use true
              tencent = {
                # qq.enable = false;
                # wechat.enable = false;
                # wemeet.enable = false;
                # dingding.enable = false;
                # feishu.enable = false;
              };

              live = {
                simple-live-app.enable = true;
                wiliwili.enable = true;
                hypontix.enable = false; # IPTV
              };

              # defalut enable true
              bitwarden.enable = true;
              authenticator.enable = true;

              kitty.enable = true;
              wezterm.enable = true;
              jetbrains = {
                enable = true;
                pycharm.enable = true;
                goland.enable = true;
                datagrip.enable = true;
              };
              envs = {
                pyenv.enable = true;
                goenv.enable = true;
                nodenv.enable = true;
                luaenv.enable = true;
              };
            };
          }
        ];
      };
    };
  };
}
