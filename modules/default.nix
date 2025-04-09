{
  flake = {
    baseModules = import ./base;
    nixosModules = import ./nixos;
    darwinModules = import ./darwin;
    homeModules = import ./home;
  };
}
