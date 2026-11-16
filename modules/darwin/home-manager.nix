{
  flake.modules.darwin.home-manager =
    {
      config,
      inputs,
      lib,
      self,
      username,
      homeManagerNixpkgsInput,
      hostName,
      class,
      myvars,
      ...
    }:
    {
      imports = [
        self.modules.darwin.home-manager-backup
      ];

      # An explicit Home Manager nixpkgs input selects a private package set.
      # Otherwise, reuse nix-darwin's package set.
      home-manager.useGlobalPkgs = homeManagerNixpkgsInput == null;
      home-manager.useUserPackages = true;

      home-manager.sharedModules =
        lib.optionals (!config.home-manager.useGlobalPkgs) [
          self.modules.homeManager.core
        ]
        ++ lib.optional (homeManagerNixpkgsInput != null) {
          _module.args.pkgsPath = inputs.${homeManagerNixpkgsInput}.outPath;
        };

      # Pass nix-darwin special arguments into Home Manager.
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          self
          username
          hostName
          class
          myvars
          ;
      };
    };
}
