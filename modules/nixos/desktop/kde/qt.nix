{
  lib,
  config,
  ...
}:
let
  cfgKde = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfgKde.enable {

    qt = {
      platformTheme = "kde6";
      style = "kvantum";
    };

  };
}
