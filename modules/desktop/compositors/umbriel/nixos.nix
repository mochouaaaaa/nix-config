{
  flake.modules.nixos."desktop.umbriel" =
    {
      self,
      lib,
      config,
      username,
      ...
    }:
    {

      imports = [ self.modules.nixos."desktop.common" ];

      programs.umbriel = {
        enable = true;
      };

      services.gvfs.enable = true;

      home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
        self.modules.homeManager."desktop.umbriel"
      ];
    };
}
