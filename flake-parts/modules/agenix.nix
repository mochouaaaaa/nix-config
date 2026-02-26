{ inputs, ... }:
{
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem =
    { config, ... }:
    {
      agenix-rekey.nixosConfigurations = inputs.self.nixosConfigurations;
      agenix-rekey.darwinConfigurations = inputs.self.darwinConfigurations;
      agenix-rekey.homeConfigurations = inputs.self.homeConfigurations;
      agenix-rekey.collectHomeManagerConfigurations = true;
    };

}
