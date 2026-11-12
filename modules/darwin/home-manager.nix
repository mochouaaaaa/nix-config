{
  flake.modules.darwin.home-manager =
    {
      inputs,
      self,
      lib,
      username,
      hostName,
      myvars,
      homeManagerNixpkgsInput,
      ...
    }:
    {
      nixpkgs.config.allowUnfree = true;

      # Keep Home Manager's package set independent from the OS package set.
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;

      # Pass nix-darwin special arguments into Home Manager.
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          self
          username
          hostName
          myvars
          homeManagerNixpkgsInput
          ;
      };

      home-manager.sharedModules = [
        {
          _module.args.pkgsPath = lib.mkForce inputs.${homeManagerNixpkgsInput}.outPath;
        }
      ];
    };
}
