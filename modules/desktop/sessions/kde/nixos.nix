{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.kde" = {
      includes = [
        aspects."desktop.common"
        (inputs.flake-aspects.lib.forward {
          each = [ { userName = "mochou"; } ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [ "home-manager" "users" user.userName ];
          fromAspect = _: aspects."desktop.kde";
        })
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
