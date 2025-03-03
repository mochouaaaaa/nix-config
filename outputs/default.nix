{
  self,
  nixpkgs,
  pre-commit-hooks,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib {inherit lib;};
  myvars = import ../vars {inherit lib;};

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # so that I can use them in all my nixos/home-manager/darwin modules.
  genSpecialArgs = system:
    inputs
    // rec {
      inherit mylib myvars;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit
          system
          ; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      isNixos = builtins.pathExists "/etc/nixos";
      isLinux = nixpkgs.legacyPackages.${system}.stdenv.isLinux && !isNixos;
      isDarwin = nixpkgs.legacyPackages.${system}.stdenv.isDarwin;
    };

  # This is the args for all the haumea modules in this folder.
  args = {inherit inputs lib mylib myvars genSpecialArgs;};

  # modules for each supported system
  nixosSystems = {
    x86_64-linux =
      import ./x86_64-linux/nixos.nix (args // {system = "x86_64-linux";});
  };
  darwinSystems = {
    x86_64-darwin = import ./x86_64-darwin (args // {system = "x86_64-darwin";});
  };

  otherSystems = {
    x86_64-linux =
      import ./x86_64-linux/home.nix (args // {system = "x86_64-linux";});
  };

  allSystems = nixosSystems // darwinSystems // otherSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  otherSystemValues = builtins.attrValues otherSystems;

  allSystemValues =
    nixosSystemValues
    ++ darwinSystemValues
    ++ otherSystemValues;

  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in {
  # Add attribute sets into outputs, for debugging
  debugAttrs = {
    inherit nixosSystems darwinSystems otherSystems allSystems allSystemNames;
  };

  # NixOS Hosts
  nixosConfigurations =
    lib.attrsets.mergeAttrsList
    (map (it: it.nixosConfigurations or {}) nixosSystemValues);

  # macOS Hosts
  darwinConfigurations =
    lib.attrsets.mergeAttrsList
    (map (it: it.darwinConfigurations or {}) darwinSystemValues);

  # nix home-manager Config
  homeConfigurations =
    lib.attrsets.mergeAttrsList
    (map (it: it.homeConfigurations or {}) otherSystemValues);

  # Packages
  packages = forAllSystems (system: allSystems.${system}.packages or {});

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == {}) allSystemValues;

  # Format the nix code in this flake
  formatter = forAllSystems (
    # alejandra is a nix formatter with a beautiful output
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
