{
  flake.aspects = { aspects, ... }: {
    desktop-cosmic = {
      includes = [
        (aspects.desktop-common { })
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
