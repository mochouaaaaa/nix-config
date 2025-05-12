{ pkgs, ... }:
{
  home.packages = with pkgs; [
    maple-mono.NF
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # FIXME: 如果不加上字体号会导致titlebar出现在显示器外部，启动器也有问题
      font-name = "Monaco Nerd Font 11";
      document-font-name = "Monaco Nerd Font";
      monospace-font-name = "Maple Mono NF";
      titlebar-font = "inter";
    };
  };
}
