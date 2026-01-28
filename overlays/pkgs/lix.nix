final: prev: {
  inherit (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;

  nix-direnv = prev.nix-direnv.override {
    nix = final.lixPackageSets.latest.lix;
  };
}
