{
  flake.aspects = { aspects, ... }: {
    "desktop.umbriel" = {
      includes = [
        aspects."desktop.common"
      ];

      nixos = {
        programs.umbriel = {
          enable = true;
        };

        services.gvfs.enable = true;
      };
    };
  };
}
