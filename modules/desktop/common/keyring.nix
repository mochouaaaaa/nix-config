{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "preservation".nixos =
      { lib, config, username, ... }:
      {
        profiles.preservation.users.${username}.directories =
          lib.optionals config.services.gnome.gnome-keyring.enable [
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }
          ];
      };

    "desktop.keyring".nixos = _: {
      services = {
        gnome = {
          gnome-keyring.enable = true;
          gcr-ssh-agent.enable = false;
        };
      };
    };

    "desktop.hyprland".includes = [ aspects."desktop.keyring" ];
    "desktop.niri".includes = [ aspects."desktop.keyring" ];
  };
}
