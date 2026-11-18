{ self, ... }:
{
  # Compatibility aggregate: retain the previous all-in-one desktop entry.
  flake.modules.homeManager."desktop.common" = {
    imports = [
      self.modules.homeManager."desktop.user"
    ];
  };

  flake.modules.nixos."desktop.common" =
    {
      self,
      username,
      ...
    }:
    {
      imports = [
        self.modules.nixos."desktop.base"
        self.modules.nixos."desktop.hardware"
      ];

      home-manager.users.${username}.imports = [
        self.modules.homeManager."desktop.common"
      ];
    };
}
