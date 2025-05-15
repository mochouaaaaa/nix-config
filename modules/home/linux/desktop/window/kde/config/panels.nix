{ config, lib, ... }:
let
  cfg = config.modules.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      panels = [
        {
          height = 39;
          lengthMode = "fill"; # 填充屏幕
          location = "top"; # 置顶 floating top left right bottom
          floating = true; # 窗口模式
          alignment = "center"; # 居中
          opacity = "adaptive"; # 自适应
          screen = null; # 屏幕编号0123或者all
          widgets = [
            {
              name = "com.github.chrtall.kppleMenu";
              config = {
                PreloadWeight = 60;
                popupHeight = 288;
                popupWidth = 226;
                ConfigDialog = {
                  DialogHeight = 540;
                  DialogWidth = 720;
                };
                Advanced = {
                  icon = "distributor-logo-nixos";
                  lockScreenSettings = "qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock";
                  logOutSettings = "qdbus org.kde.Shutdown /Shutdown logout";
                  restartSettings = "qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndReboot";
                  showAdvancedMode = true;
                  shutDownSettings = "qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndShutdown";
                };
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 20;
                };
              };
            }
            {
              name = "org.kde.windowtitle";
              config = {
                Appearance = {
                  txt = "%a";
                  visible = false;
                };
                Behavior = {
                  closeAllowed = false;
                  maxminAllowed = false;
                  scrollAllowed = false;
                  showTooltip = false;
                };
                ConfigDialog = {
                  DialogHeight = 540;
                  DialogWidth = 720;
                };
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 20;
                };
              };
            }
            "org.kde.plasma.appmenu"
            "org.kde.plasma.panelspacer"
            {
              name = "org.kde.netspeedWidget";
              config = {
                ConfigDialog = {
                  DialogHeight = 540;
                  DialogWidth = 720;
                };
                General = {
                  fontSize = 60;
                  ShortUnits = true;
                  showLowSpeeds = true;
                  speedUnits = "bits";
                };
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 10;
                };
              };
            }
            {
              name = "org.kde.plasma.resources-monitor";
              config = {
                Appearance = {
                  fillPanel = true;
                  fontScale = 30;
                  graphFillOpacity = 30;
                  graphHeight = 20;
                  graphSpacing = 12;
                  graphWidth = 20;
                };
                ConfigDialog = {
                  DialogHeight = 540;
                  DialogWidth = 720;
                };
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 10;
                };
              };
            }
            {
              name = "org.kde.plasma.systemtray";
              config = {
                PreloadWeight = 55;
                SystrayContainmentId = 276;
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 10;
                };
              };
            }
            {
              name = "KdeControlStation";
              config = {
                PreloadWeight = 80;
                popupHeight = 509;
                popupWidth = 380;
                ConfigDialog = {
                  DialogHeight = 540;
                  DialogWidth = 720;
                };
                Appearance = {
                  icon = "adjustlevels";
                  darkGlobalTheme = "com.github.vinceliuice.WhiteSur-dark";
                  layout = 1;
                  lightGlobalTheme = "com.github.vinceliuice.WhiteSur-alt";
                  lightTheme = "WhiteSurAlt";
                  preferChangeGlobalTheme = true;
                };
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 10;
                };
              };
            }
            {
              name = "org.kde.plasma.digitalclock";
              config = {
                PreloadWeight = 65;
                popupHeight = 450;
                popupWidth = 560;
                Appearance = {
                  autoFontAndSize = false;
                  customDateFormat = "M月d日 ddd";
                  dateDisplayFormat = "BesideTime";
                  dateFormat = "custom";
                  fontFamily = "Monaco Nerd Font";
                  fontSize = "11";
                  fontStyleName = "Regular";
                  fontWeight = "400";
                  showSeconds = "Never";
                };
                ConfigDialog = {
                  DialogHeight = 540;
                  DialogWidth = 720;
                };
              };
            }
            {
              name = "org.kde.plasma.panelspacer";
              config = {
                General = {
                  expanding = false;
                  length = 10;
                };
              };
            }
          ];
        }
      ]; # 自定义面板
    };

  };
}
