{ inputs, ... }: {

  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      packages.agenix = config.agenix-rekey.package;

      agenix-rekey.nixosConfigurations = inputs.self.nixosConfigurations;
      agenix-rekey.darwinConfigurations = inputs.self.darwinConfigurations;
      agenix-rekey.homeConfigurations = inputs.self.homeConfigurations;
      agenix-rekey.collectHomeManagerConfigurations = true;

      devShells.agenix = pkgs.mkShell {
        nativeBuildInputs = [ config.agenix-rekey.package ];
        env.AGENIX_REKEY_ADD_TO_GIT = true;

        packages = [ pkgs.age ];
      };
    };

}
