{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.desktop.component.ashell;
in
{

  options.modules.desktop.component.ashell = {
    enable = lib.mkEnableOption "Ashell" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      ashell
    ];
  };
}
