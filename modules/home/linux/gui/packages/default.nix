{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.importModule' ./.;

  home.packages = with pkgs; [
    # Automatically trims your branches whose tracking remote refs are merged or gone
    # It's really useful when you work on a project for a long time.
    git-trim
    gitleaks
  ];
}
