{ pkgs, lib, ... }:
{

  home.shellAliases = {
    df = "${lib.getExe pkgs.duf}";
  };

  home.packages = with pkgs; [

    tree
    trash-cli

    # Misc
    tldr

    # search for files by its content, replacement of grep
    (ripgrep.override { withPCRE2 = true; })

    # nix-output-monitor
    # hydra-check # check hydra(nix's build farm) for the build status of a package
    # nix-init # generate nix derivation from url
    # https://github.com/nix-community/nix-melt
    nix-melt # A TUI flake.lock viewer
    # https://github.com/utdemir/nix-tree
    nix-tree # A TUI to visualize the dependency graph of a nix derivation
  ];
}
