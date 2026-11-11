{
  flake.modules.homeManager."desktop.common" =
    { self, config, ... }:
    let
      cfg = config.profiles.terminal.kitty;
    in
    {

      imports = [
        self.modules.homeManager."programs.kitty"
      ];

      profiles.terminal.kitty = {
        extraConfig = [
          "adjust_line_height 100%"
          "adjust_column_width 100%"
          "window_padding_width 0 4"
          "mouse_map        ctrl+left click ungrabbed mouse_handle_click link"
        ];
      };

      xdg = {
        configFile = {
          "kitty/kitty.app.png".source = "${cfg.icon}/kitty-dark.png";
        };

        mimeApps.defaultApplicationPackages = [ config.programs.kitty.package ];
      };

    };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.kitty.enable
          [
            ".config/kitty"
          ];
    };

  flake.modules.homeManager."desktop.gnome" = {
    profiles.packages.terminal.kitty.extraConfig = [ "background_opacity 1" ];
  };

  flake.modules.homeManager."desktop.kde" = {
    profiles.packages.terminal.kitty.extraConfig = [ "# hide_window_decorations yes" ];
  };

}
