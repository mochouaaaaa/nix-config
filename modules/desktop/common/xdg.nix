{
  flake.modules.homeManager."desktop.common" =
    {
      config,
      pkgs,
      ...
    }:
    {
      home = {
        packages = with pkgs; [
          xdg-utils
          xdg-user-dirs
        ];
        shellAliases.open = "xdg-open";
      };

      xdg = {
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
          extraConfig.SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
        };

        configFile."mimeapps.list".force = true;

        mimeApps.enable = true;

        portal = {
          # enable = lib.mkDefault true;

          config = {
            common = {
              default = [ "gtk" ];
              "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
              # 只在安装了 xdg-desktop-portal-gnome 的主机上保留
              # "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
            };
          };

          xdgOpenUsePortal = true;

          extraPortals = with pkgs; [
            xdg-desktop-portal
            xdg-desktop-portal-gtk
          ];

        };
      };
    };
}
