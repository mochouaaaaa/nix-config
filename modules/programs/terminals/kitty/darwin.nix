{

  flake.aspects."programs"."darwin" = {
    homebrew.casks = [
      "kitty"
    ];
  };

  flake.aspects."darwin"."homeManager" =
    { lib, ... }:
    {
      programs.kitty = {
        package = lib.mkForce null;
        autoThemeFiles = {
          light = "Catppuccin-Latte";
          dark = "Catppuccin-Mocha";
          noPreference = "Catppuccin-Mocha";
        };
        darwinLaunchOptions = [
          "--single-instance"
          "--listen-on=unix:/tmp/mykitty.sock"
        ];
      };
      # xdg.configFile = {
      #   "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
      # };

    };
}
