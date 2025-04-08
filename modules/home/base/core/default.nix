{
  self,
  lib,
  config,
  isLinux,
  ...
}:
{
  imports = self.mylib.scanPaths ./.;

  options = {
    dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.config/${self.myvars.dotfilePath}";
      example = "${config.home.homeDirectory}/.config/${self.myvars.dotfilePath}";
      description = "Location of the dotfiles working copy";
    };

    keymaps.Super = lib.mkOption {
      type = lib.types.str;
      default = "cmd";
      description = "The key used for the super key.";
    };
  };

  config = lib.mkIf isLinux {
    targets.genericLinux.enable = true;
  };
}
