{

  flake.modules.nixos."desktop.hyprland" = { self, ... }: {
    imports = [
      self.modules.nixos."desktop.greeter.noctalia"
    ];
  };

  flake.modules.nixos."desktop.niri" = { self, ... }: {
    imports = [
      self.modules.nixos."desktop.greeter.noctalia"
    ];
  };

  flake.modules.nixos."desktop.greeter.noctalia" =
    {
      pkgs,
      ...
    }:
    {

      services.displayManager.noctalia-greeter = {
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
          keyboard = {
            layout = "us";
          };
        };
      };

      profiles.preservation.directories = [
        "/var/lib/noctalia-greeter"
      ];

    };

}
