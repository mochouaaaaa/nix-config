{
  modules'.packages = {
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

    obsidian.enable = true;
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
    };
  };
}
