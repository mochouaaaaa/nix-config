{ self, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.user" = {
      homeManager.imports = [
        self.modules.homeManager."desktop.user"
      ];
    };

    "desktop.common" = {
      includes = [
        aspects."desktop.base"
        aspects."desktop.hardware"
        aspects."desktop.user"
      ];

      nixos =
        {
          username,
          ...
        }:
        {
          home-manager.users.${username}.imports = [
            self.modules.homeManager."desktop.common"
          ];
        };
    };
  };
}
