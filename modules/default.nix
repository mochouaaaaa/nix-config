{
  flake = {
    sharedModules = import ./sharedModule;
    nixosModules = import ./nixos; # NixOS modules
    darwinModules = import ./darwin; # darwin modules
    homeModules = import ./home; # home-manager modules
  };
}
