{
  self,
  lib,
  ...
}:
{
  imports = self.importModule' ./. ++ [
    ../../component
  ];

  options.modules.desktop.hyprland = {
    enable = lib.mkOption {
      default = builtins.getEnv "DESKTOP" == "hyprland";
      type = lib.types.bool;
      description = "Enable Hyprland desktop environment.";
    };
  };

}
