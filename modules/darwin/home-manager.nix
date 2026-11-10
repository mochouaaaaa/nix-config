{
  flake.modules.darwin.home-manager = {
    # Reuse nix-darwin's pkgs (nixpkgs-darwin 26.05) instead of letting
    # Home Manager instantiate its follows=nixpkgs unstable input on Intel Mac.
    nixpkgs.config.allowUnfree = true;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
