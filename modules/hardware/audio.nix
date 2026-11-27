{
  flake.aspects."hardware.audio".nixos =
    {
      pkgs,
      ...
    }:
    {
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

      boot.kernelModules = [ "snd_aloop" ];

      security.rtkit.enable = true;
    };
}
