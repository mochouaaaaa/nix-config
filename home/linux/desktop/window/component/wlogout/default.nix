{lib, ...}: let
  layout = builtins.readFile ./layout;
  layoutJson = builtins.fromJSON layout;
in {
  programs.wlogout = {
    enable = true;
    style = lib.mkForce ./style.css;
    layout = layoutJson;
  };

  xdg.configFile = {
    "wlogout/icons" = {
      source = ./icons;
      recursive = true;
      force = true;
    };
  };
}
