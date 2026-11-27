{
  flake.modules.homeManager.linux =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      kitty-icon = pkgs.fetchFromGitHub {
        owner = "DinkDonk";
        repo = "kitty-icon";
        rev = "main";
        hash = "sha256-f+uiesvd0Vdoef6X2kqmbd+4CX2TXdkUGwZdzaKg5bY=";
      };

    in
    {

      programs.kitty = {
        extraConfig = ''
          adjust_line_height 100%
          adjust_column_width 100%
          window_padding_width 0 4
        '';
      };

      xdg = {
        configFile = {
          "kitty/kitty.app.png" = lib.mkIf config.programs.kitty.enable {
            source = "${kitty-icon}/kitty-dark.png";
          };
        };

        # mimeApps.defaultApplicationPackages = lib.optionals config.programs.kitty.enable [
        #   config.programs.kitty.package
        # ];
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

  flake.modules.homeManager."desktop.kde" = {
    programs.kitty.extraConfig = "# hide_window_decorations yes";
  };

}
