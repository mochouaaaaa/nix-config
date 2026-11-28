{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.cosmic" = {
      includes = [
        aspects."desktop.common"
        (inputs.flake-aspects.lib.forward {
          each = [ { userName = "mochou"; } ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [ "home-manager" "users" user.userName ];
          fromAspect = _: aspects."desktop.cosmic";
        })
      ];

      nixos =
        { pkgs, ... }:
        {
          services.desktopManager.cosmic.enable = true;

          services.displayManager.cosmic-greeter.enable = true;

          environment.cosmic.excludePackages = with pkgs; [
            cosmic-term
            cosmic-store
            cosmic-edit
          ];
        };
    };
  };
}
