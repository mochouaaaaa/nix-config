{
  lib,
  config,
  ...
}:
let
  cfgKde = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfgKde.enable {

    qt = {
      platformTheme = "kde6";
      style = "kvantum";
    };

  };
}
