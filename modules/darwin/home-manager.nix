{
  flake.modules.darwin.home-manager =
    {
      inputs,
      self,
      username,
      hostName,
      class,
      myvars,
      ...
    }:
    {
      imports = [
        self.modules.darwin.home-manager-backup
      ];

      # Home Manager shares nix-darwin's package set.
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      # Pass nix-darwin special arguments into Home Manager.
      home-manager.extraSpecialArgs = {
        inherit inputs self username hostName class myvars;
      };
    };
}
