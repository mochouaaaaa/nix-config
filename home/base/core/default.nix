{
  lib,
  config,
  myvars,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  options = {
    dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.config/${myvars.dotfilePath}";
      example = "${config.home.homeDirectory}/.config/${myvars.dotfilePath}";
      description = "Location of the dotfiles working copy";
    };
  };
}
