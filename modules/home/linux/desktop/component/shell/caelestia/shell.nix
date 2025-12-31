{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.shell.caelestia;
in
{

  config = lib.mkIf cfg.enable {

    programs = {
      caelestia = {
        settings = {
          appearance = {
            anim = {
              durations = {
                scale = 1;
              };
            };
            font = {
              family = {
                material = "Material Symbols Rounded";
                mono = "CaskaydiaCove NF";
                sans = "Rubik";
              };
              size = {
                scale = 1;
              };
            };
            padding = {
              scale = 1;
            };
            rounding = {
              scale = 1;
            };
            spacing = {
              scale = 1;
            };
            transparency = {
              enabled = true;
              base = 0.85;
              layers = 0.4;
            };
          };

          general = {
            apps = {
              terminal = [ "kitty" ];
              audio = [ "pavucontrol" ];
              playback = [ "mpv" ];
              explorer = [ "nautilus" ];
            };
            idle = {
              lockBeforeSleep = true;
              inhibitWhenAudio = true;
              timeouts = [
                {
                  timeout = 600;
                  idleAction = "lock";
                }
                {
                  timeout = 555;
                  idleAction = "dpms off";
                  returnAction = "dpms on";
                }
                {
                  timeout = 1800;
                  idleAction = [
                    "systemctl"
                    "suspend-then-hibernate"
                  ];
                }
              ];
            };
          };

          background = {
            desktopClock = {
              enabled = true;
            };
            enabled = true;
            visualiser = {
              enabled = true;
              autoHide = true;
              rounding = 1;
              spacing = 1;
            };
          };

          bar = {
            dragThreshold = 10;
            entries = [
              {
                id = "logo";
                enabled = true;
              }
              {
                id = "workspaces";
                enabled = true;
              }
              {
                id = "spacer";
                enabled = true;
              }
              {
                id = "activeWindow";
                enabled = true;
              }
              {
                id = "spacer";
                enabled = true;
              }
              {
                id = "tray";
                enabled = true;
              }
              {
                id = "clock";
                enabled = true;
              }
              {
                id = "statusIcons";
                enabled = true;
              }
              {
                id = "power";
                enabled = true;
              }
            ];
            persistent = true;
            scrollActions = {
              brightness = true;
              workspaces = true;
              volume = true;
            };
            showOnHover = true;
            status = {
              showAudio = true;
              showBattery = false;
              showBluetooth = true;
              showKbLayout = false;
              showNetwork = true;
            };
            tray = {
              background = false;
              recolour = false;
            };
            workspaces = {
              activeIndicator = true;
              activeLabel = "󰮯 ";
              activeTrail = false;
              label = "  ";
              occupiedBg = true;
              occupiedLabel = "󰮯 ";
              perMonitorWorkspaces = true;
              rounded = true;
              showWindows = true;
              shown = 5;
            };
          };

          border = {
            rounding = 13;
            thickness = 1;
          };

          dashboard = {
            enabled = true;
            dragThreshold = 50;
            mediaUpdateInterval = 500;
            showOnHover = true;
            visualiserBars = 45;
          };

          launcher = {
            actionPrefix = ">";
            dragThreshold = 50;
            vimKeybinds = true;
            enableDangerousActions = false;
            maxShown = 8;
            maxWallpapers = 9;
            useFuzzy = {
              # 当使用launcher的时候需要开启这个
              apps = true;
              actions = true;
              schemes = true;
              variants = true;
              wallpapers = true;
            };
          };

          lock = {
            recolourLogo = false;
          };

          notifs = {
            actionOnClick = true;
            clearThreshold = 0.3;
            defaultExpireTimeout = 5000;
            expandThreshold = 20;
            expire = true;
          };

          osd = {
            enableBrightness = true;
            enableMicrophone = true;
            hideDelay = 2000;
          };

          paths = {
            mediaGif = "root:/assets/bongocat.gif";
            sessionGif = "root:/assets/kurukuru.gif";
            wallpaperDir = "~/Pictures/Wallpapers";
          };

          services = {
            audioIncrement = 0.1;
            weatherLocation = "39.9042,116.4074";
            useFahrenheit = false;
            useTwelveHourClock = false;
            smartScheme = true;
          };

          session = {
            dragThreshold = 30;
            vimKeybinds = false;
            commands = {
              logout = [
                "loginctl"
                "terminate-user"
                ""
              ];
              shutdown = [
                "systemctl"
                "poweroff"
              ];
              hibernate = [
                "systemctl"
                "hibernate"
              ];
              reboot = [
                "systemctl"
                "reboot"
              ];
            };
          };
        };
      };
    };

  };
}
