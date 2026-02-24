{ pkgs, ... }:
{
  programs.emacs = {
    package = pkgs.emacs-gtk;
  };
}
