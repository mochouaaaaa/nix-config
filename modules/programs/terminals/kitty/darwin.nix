{

  flake.modules.darwin.programs = {
    homebrew.casks = [
      "kitty"
    ];
  };

  flake.modules.homeManager.darwin =
    { lib, config, ... }:
    let
      cfg = config.profiles.terminal.kitty;
    in
    {
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
}
