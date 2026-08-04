{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      # settings = {
      #   ui = {
      #     boxBorderEnabled = false;
      #     fontDefault = "${config.profiles.fonts.default}";
      #     fontDefaultScale = 1;
      #     fontFixed = "${config.profiles.fonts.default}";
      #     fontFixedScale = 1;
      #     networkPanelView = "wifi";
      #     panelBackgroundOpacity = 0.68;
      #     panelsAttachedToBar = true;
      #     scrollbarAlwaysVisible = true;
      #     settingsPanelMode = "centered";
      #     settingsPanelSideBarCardStyle = false;
      #     tooltipsEnabled = true;
      #     translucentWidgets = true;
      #   };
      # };
    };
  };
}
