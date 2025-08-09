{
  pkgs,
  ...
}:
{
  #############################################################
  #
  #  Basic settings for development environment
  #
  #  Please avoid to install language specific packages here(globally),
  #  instead, install them:
  #     1. per IDE, such as `programs.neovim.extraPackages`
  #     2. per-project, using https://github.com/the-nix-way/dev-templates
  #
  #############################################################

  home.packages = with pkgs; [
    clipboard-jh

    # db related
    pkgs.mycli
    pkgs.pgcli
    mongosh
    sqlite

    # ai related
    pkgs.python312Packages.huggingface-hub # huggingface-cli

    # misc
    pkgs.devbox
    bfg-repo-cleaner # remove large files from git history
    protobuf # protocol buffer compiler

    # solve coding extercises - learn by doing
    exercism
  ];
}
