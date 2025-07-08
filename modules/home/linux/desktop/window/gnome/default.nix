{
  lib,
  ...
}:
{
  imports = lib.importModule' ./.;

  options.modules.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "gnome";
      description = "Enable GNOME desktop environment.";
    };
  };

}
