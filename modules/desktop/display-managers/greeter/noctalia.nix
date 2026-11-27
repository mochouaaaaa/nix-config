{

  flake.aspects = { aspects, ... }: {
    "desktop.hyprland".includes = [ aspects."desktop.greeter.noctalia" ];
    "desktop.niri".includes = [ aspects."desktop.greeter.noctalia" ];
    "desktop.umbriel".includes = [ aspects."desktop.greeter.noctalia" ];
    "desktop.greeter.noctalia".nixos =
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
  };

  flake.modules.nixos.preservation =
    { lib, config, ... }:
    {
      profiles.preservation.directories =
        lib.optionals config.services.displayManager.noctalia-greeter.enable [
          "/var/lib/noctalia-greeter"
        ];
    };

}
