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

        mimeApps.enable = true;

        portal = {
          enable = true;

          config = {
            common = {
              default = [ "gtk" ];
              "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };
          };

          xdgOpenUsePortal = true;

          # The compositor-specific module adds its own portal backend.
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
          ];
        };
      };
    };
}
