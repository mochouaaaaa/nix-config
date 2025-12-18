# hosts/nixos/host.nix
# 此文件包含特定于 mochou@nixos 主机的模块启用开关和配置细节。
# 它将顶层 flake.nix 中的内联配置提取到此处，以提高可读性。
{
  nixosModules = [
    {
      modules' = {
        network.proxy.clash-party.enable = true;
        virtual = {
          virtualbox.enable = false;
          vmware.enable = false;
          qemu.enable = true;
          docker.enable = true;
        };
        packages = {
          database-suite.enable = true;
          steam = {
            enable = true;
          };
        };
      };
    }
  ];

  homeManagerModules = [
    {
      modules' = {
        packages = {
          firefox.enable = true;
          google-chrome.enable = true;

          tencent = {
            wechat.enable = true;
            wemeet.enable = true;
            dingding.enable = true;
            feishu.enable = true;
          };

          obsidian.enable = true;
          live = {
            simple-live-app.enable = true;
            wiliwili.enable = true;
            iptv.enable = true;
          };

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
            clion = true;
          };
          envs = {
            pyenv.enable = true;
            goenv.enable = true;
            nodenv.enable = false;
          };
        };
      };
    }
  ];
}
