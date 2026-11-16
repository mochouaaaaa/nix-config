{
  flake.modules.darwin.programs =
    { config, lib, username, ... }:
    {
      homebrew.casks = lib.optionals config.home-manager.users.${username}.programs.kitty.enable [
        "kitty"
      ];
    };

  flake.modules.homeManager.darwin =
    { lib, config, ... }:
    let
      cfg = config.profiles.terminal.kitty;
    in
    {
      config = lib.mkIf config.programs.kitty.enable {
        programs.kitty = {
          package = lib.mkForce null;
          darwinLaunchOptions = [
            "--single-instance"
            "--listen-on=unix:/tmp/mykitty.sock"
          ];
        };
        xdg.configFile = {
          "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
        };
      };
    };
}
