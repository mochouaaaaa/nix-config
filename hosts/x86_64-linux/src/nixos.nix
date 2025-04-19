{
  lib,
  self,
  inputs,
  system,
  genSpecialArgs,
  ...
}@args:
let
  modules = {
    nixos-modules = [
      ../nixos

      self.nixosModules.base
      self.nixosModules.services
      self.nixosModules.virtual
      {

        modules.network.proxy.clash.enable = true;
        modules.virtual = {
          docker.enable = true;
        };
      }
    ];

    home-modules = [
      self.homeModules.base.home
      self.homeModules.base.core
      self.homeModules.base.tools

      self.homeModules.linux.base
      self.homeModules.linux.gui

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
in
{
  nixosConfigurations = {
    nixos = self.mylib.nixosSystem (modules // args);
  };
}
