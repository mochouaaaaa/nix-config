{

  flake = {
    baseModules = import ./base;
    nixosModules = import ./nixos; # NixOS modules
    darwinModules = import ./darwin; # darwin modules
    homeModules = import ./home; # home-manager modules
  };
}
