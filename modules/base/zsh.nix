{ pkgs, ... }:
{
  # Default shell
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];
}
