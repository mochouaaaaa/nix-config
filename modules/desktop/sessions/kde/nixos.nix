{
  flake.aspects = { aspects, ... }: {
    desktop-kde = {
      includes = [
        (aspects.desktop-common { })
      ];

      nixos =
        {
          lib,
          pkgs,
          ...
        }:
        {
          services = {
            displayManager = {
              sddm = {
                enable = true;
                wayland.enable = true;
              };
            };
            desktopManager.plasma6.enable = true;
          };

          security.pam.services = {
            login.kwallet.enable = lib.mkForce false;
            kde.kwallet.enable = lib.mkForce false;
          };

          qt = {
            enable = true;
            style = "kvantum";
          };

          programs.xwayland.enable = true;

          environment.plasma6.excludePackages = with pkgs.kdePackages; [
            plasma-browser-integration
            konsole
            # oxygen is normally not installed by default.
            # Keep krunner (Plasma's launcher) and kwallet (password wallet).
          ];
        };
    };
  };
}
