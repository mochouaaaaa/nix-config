{
  flake.modules.homeManager.linux =
    { lib, config, ... }:
    let
      cfg = config.profiles.terminal.kitty;
    in
    {

      profiles.terminal.kitty = {
        extraConfig = [
          "adjust_line_height 100%"
          "adjust_column_width 100%"
          "window_padding_width 0 4"
        ];
      };

      xdg = {
        configFile = {
          "kitty/kitty.app.png" = lib.mkIf cfg.enable {
            source = "${cfg.icon}/kitty-dark.png";
          };
        };

        mimeApps.defaultApplicationPackages = lib.optionals cfg.enable [
          config.programs.kitty.package
        ];
      };

    };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      options,
      username,
      ...
    }:
    let
      hasHm = options ? home-manager;
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (hasHm && config.home-manager.users.${username}.programs.kitty.enable)
          [
            ".config/kitty"
          ];
    };

  flake.modules.homeManager."desktop.gnome" = {
    profiles.terminal.kitty.extraConfig = [ "background_opacity 1" ];
  };

  flake.modules.homeManager."desktop.kde" = {
    profiles.terminal.kitty.extraConfig = [ "# hide_window_decorations yes" ];
  };

}
