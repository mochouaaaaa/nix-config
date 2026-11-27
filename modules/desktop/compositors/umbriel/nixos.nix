{
  flake.aspects = { aspects, ... }: {
    "desktop.umbriel" = {
      includes = [
        aspects."desktop.common"
      ];

      nixos =
        {
          self,
          lib,
          config,
          username,
          ...
        }:
        {
          programs.umbriel = {
            enable = true;
          };

          services.gvfs.enable = true;

          home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
            self.modules.homeManager."desktop.umbriel"
          ];
        };
    };
  };
}
