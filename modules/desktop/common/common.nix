{ self, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.common" = {
      includes = [
        aspects."desktop.base"
        aspects."desktop.hardware"
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

      homeManager = {
        imports = [
          self.modules.homeManager."desktop.user"
        ];
      };
    };
  };
}
