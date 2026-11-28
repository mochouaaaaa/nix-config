{
  flake.aspects = { aspects, ... }: {

    desktop-hyprland.includes = [ aspects.greeter._.noctalia ];
    desktop-niri.includes = [ aspects.greeter._.noctalia ];
    desktop-umbriel.includes = [ aspects.greeter._.noctalia ];

    greeter.provides.noctalia.nixos =
      { lib, pkgs, ... }:
      {
        services.displayManager = {
          gdm.enable = lib.mkForce false;
          noctalia-greeter = {
            enable = true;
            cursorTheme = {
              name = "Bibata-Modern-Ice";
              package = pkgs.bibata-cursors;
            };
            settings = {
              cursor = {
                theme = "Bibata-Modern-Ice";
                size = 24;
                path = "${pkgs.bibata-cursors}/share/icons";
              };
              keyboard.layout = "us";
            };
          };
        };
      };

    preservation.nixos =
      { lib, config, ... }:
      {
        profiles.preservation.directories =
          lib.optionals (config.services.displayManager.noctalia-greeter.enable or false)
            [
              "/var/lib/noctalia-greeter"
            ];
      };
  };
}
