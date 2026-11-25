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
    let
      filterAgenixConfigurations =
        configurations:
        pkgs.lib.filterAttrs (_: host: pkgs.lib.hasAttrByPath [ "age" "rekey" ] host.config) configurations;
    in
    {

      packages.agenix = config.agenix-rekey.package;

      # agenix-rekey.nixosConfigurations = inputs.self.nixosConfigurations;
      # agenix-rekey.darwinConfigurations = inputs.self.darwinConfigurations;
      # agenix-rekey.homeConfigurations = inputs.self.homeConfigurations;

      agenix-rekey.nixosConfigurations = filterAgenixConfigurations inputs.self.nixosConfigurations;
      agenix-rekey.darwinConfigurations = filterAgenixConfigurations inputs.self.darwinConfigurations;
      agenix-rekey.homeConfigurations = filterAgenixConfigurations inputs.self.homeConfigurations;
      agenix-rekey.collectHomeManagerConfigurations = true;

    };

}
