{
  self,
  lib,
  ...
}:
{
  imports = self.importModule' ./.;

  options.modules.desktop.kde = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "kde";
      description = "Enable KDE desktop environment.";
    };
  };

}
