{lib, ...}: let
  jsonFile = builtins.readFile ./config.json;
  settings = builtins.fromJSON jsonFile;
in {
  services.swaync = {
    enable = true;
    settings = settings;
    style = lib.mkForce ./style.css;
  };

  xdg.configFile = {
    "swaync/icons" = {
      source = ./icons;
      recursive = true;
      force = true;
    };
    "swaync/images" = {
      source = ./images;
      recursive = true;
      force = true;
    };
  };
}
