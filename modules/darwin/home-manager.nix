{
  flake.modules.darwin.home-manager =
    {
      inputs,
      lib,
      homeManagerNixpkgsInput,
      ...
    }:
    {
      nixpkgs.config.allowUnfree = true;

      # Keep Home Manager's package set independent from the OS package set.
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;

      home-manager.sharedModules = [
        {
          _module.args.pkgsPath = lib.mkForce inputs.${homeManagerNixpkgsInput}.outPath;
        }
      ];
    };
}
