{
  flake.modules.homeManager."desktop.gnome" = { lib, config, ... }: {

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        # FIXME: 如果不加上字体号会导致titlebar出现在显示器外部，启动器也有问题
        font-name = lib.mkDefault "${config.profiles.fonts.default} 11";
        document-font-name = lib.mkDefault "${config.profiles.fonts.default}";
        monospace-font-name = lib.mkDefault "${config.profiles.fonts.monospace}";
        titlebar-font = "inter";
      };
    };

  };
}
