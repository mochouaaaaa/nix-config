{lib}: let
  customConfig = rec {
    username = "mochou";
    userfullname = "mochouaaaaa";
    useremail = "nn.mochou+github@gmail.com";
    # generated by `mkpasswd -m scrypt`
    initialHashedPassword = "$7$CU..../....eljcZ6wMdzMIITQt.XFsn1$wDJIAx4MGcgDInqjtURmobO4JcYG/g9Z3OJUoIjcXZ5";

    packages = {
      wezterm = false; # default use kitty
      ollama = true;
      neovim = true;
      neovide = true;
      google-chrome = true;
      firefox = true;
      vscode = true;
      jetbrains = {
        enable = true;
        pycharm = true;
        clion = false;
        datagrip = true;
        goland = true;
      };
      qq = true;
      wechat = true;
      telegram = true;
      pot = true; # translate tool
      flameshot = true;
      obs = true;
      steam = false;
    };

    envs = {
      pyenv = true;
      goenv = true;
      luaenv = true;
      nodenv = true;
    };

    # dotfilePath = "$HOME/.config/dotfile";
    dotfilePath = "dotfile";

    wm = {
      wayland = true;
      x11 = false;
    };
    desktopName = "kde"; # hyprland gnome  niri kde
    baseDesktop = {
      hyprland = false;
      gnome = false;
      niri = false;
      kde = false;
      component = {
        stylix = false;
        rofi = true;
        swaylock = true;
        swaync = true;
        waybar = true;
        wlogout = true;
      };
    };

    desktop =
      baseDesktop
      // (
        if desktopName == "hyprland"
        then {
          hyprland = true;
        }
        else if desktopName == "gnome"
        then {
          gnome = true;
        }
        else if desktopName == "kde"
        then {
          kde = true;
        }
        else if desktopName == "niri"
        then {
          niri = true;
        }
        else {
          hyprland = true;
        }
      );

    virtual = {
      docker = true;
      qemu = false;
      virtualbox = false;
      vmware = false;
    };
  };
in
  customConfig
