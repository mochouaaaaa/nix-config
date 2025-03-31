{
  flake = {
    nixosModules = import ./nixos;
    darwinModules = import ./darwin;
    homeModules = import ./home;
  };
}
