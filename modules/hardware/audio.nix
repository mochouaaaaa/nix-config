{
  flake.modules.nixos."hardware.audio" =
    {
      lib,
      config,
      pkgs,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.services.pipewire.pulse.enable [ ".config/pulse" ]
        ++ lib.optionals config.services.pipewire.wireplumber.enable [ ".local/state/wireplumber" ];

      environment.systemPackages = with pkgs; [
        pamixer
      ];

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        # jack.enable = true;
        wireplumber.enable = true;

        raopOpenFirewall = true;

        extraConfig = {
          pipewire = {
            "99-silent-bell.conf" = {
              "context.properties" = {
                "module.x11.bell" = false;
              };
            };
            "10-airplay.conf" = {
              "context.modules" = [
                { name = "libpipewire-module-raop-discover"; }
              ];
            };
          };
        };
      };

      security.rtkit.enable = true;
    };
}
