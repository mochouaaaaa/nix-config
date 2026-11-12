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

      profiles.terminal.kitty = {
        extraConfig = [
          "mouse_map        cmd+left click ungrabbed mouse_handle_click link"
        ];
      };

      xdg.configFile = {
        "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
      };

    };
}
