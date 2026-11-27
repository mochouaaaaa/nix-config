{ ... }:
{
  flake.modules.nixos.preservation =
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

  flake.aspects = { aspects, ... }: {
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
