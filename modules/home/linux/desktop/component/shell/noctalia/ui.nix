{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        ui = {
          boxBorderEnabled = false;
          fontDefault = "Monaco Fira Nerd";
          fontDefaultScale = 1;
          fontFixed = "Monaco Fira Nerd";
          fontFixedScale = 1;
          networkPanelView = "wifi";
          panelBackgroundOpacity = 0.68;
          panelsAttachedToBar = true;
          scrollbarAlwaysVisible = true;
          settingsPanelMode = "centered";
          settingsPanelSideBarCardStyle = false;
          tooltipsEnabled = true;
          translucentWidgets = true;
        };
      };
    };
  };
}
