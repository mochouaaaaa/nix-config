{ pkgs, lib, ... }:
{

  home.shellAliases = {
    df = "${lib.getExe pkgs.duf}";
  };

  home.packages = with pkgs; [
    lftp

    tree
    trash-cli

    # Misc
    tldr
    cowsay
    gnupg

    # Modern cli tools, replacement of grep/sed/...

    # Interactively filter its input using fuzzy searching, not limit to filenames.
    luajitPackages.fzf-lua
    # search for files by its content, replacement of grep
    (ripgrep.override { withPCRE2 = true; })

    doggo # DNS client for humans
    # duf # Disk Usage/Free Utility - a better 'df' alternative
    dust # A more intuitive version of `du` in rust

    # nix-output-monitor
    # hydra-check # check hydra(nix's build farm) for the build status of a package
    # nix-init # generate nix derivation from url
    # https://github.com/nix-community/nix-melt
    nix-melt # A TUI flake.lock viewer
    # https://github.com/utdemir/nix-tree
    nix-tree # A TUI to visualize the dependency graph of a nix derivation
  ];
}
