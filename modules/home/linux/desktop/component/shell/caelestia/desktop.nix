{
  lib,
  config,
  ...
}:
let
  cfgDesktop = config.profiles.desktop;
  cfg = config.profiles.desktop.shell.caelestia;
in
{
  config = lib.mkIf (cfg.enable) (
    lib.mkMerge [

      {
        services.darkman = {
          lightModeScripts = {
            light = ''
              caelestia scheme set -n dynamic --mode light
            '';
          };
          darkModeScripts = {
            dark = ''
              caelestia scheme set -n dynamic --mode dark
            '';
          };
        };
      }

      (lib.mkIf cfgDesktop.hyprland.enable {

        wayland.windowManager.hyprland = {
          extraConfig = ''
            _G.windowOpacity = 0.78

            hl.bind("SUPER+CTRL+A", hl.dsp.exec_cmd("caelestia screenshot --region -f"))
            hl.bind("SUPER+CTRL+S", hl.dsp.exec_cmd("caelestia screenshot --r -f"))

            hl.bind("SUPER+CTRL+Q", hl.dsp.global("caelestia:lock"))
            hl.bind("SUPER+Space",  hl.dsp.global("caelestia:launcher"))
            hl.bind("SUPER+P",      hl.dsp.exec_cmd("caelestia clipboard"))
            hl.bind("SUPER+comma",  hl.dsp.exec_cmd("caelestia shell controlCenter open"))


            hl.bind("XF86MonBrightnessUp",   hl.dsp.global("caelestia:brightnessUp"))
            hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"))

            hl.bind("XF86AudioPlay",  hl.dsp.global("caelestia:mediaToggle"))
            };
            hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"))
            hl.bind("XF86AudioNext",  hl.dsp.global("caelestia:mediaNext"))
            hl.bind("XF86AudioPrev",  hl.dsp.global("caelestia:mediaPrev"))
            hl.bind("XF86AudioStop",  hl.dsp.global("caelestia:mediaStop"))

            hl.layer_rule{
                name = "caelestia-blur",
                match = { namespace = "caelestia-drawers|launcher" },
                blur = true,
            }
            hl.layer_rule{ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true }
            hl.layer_rule{ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" }
            hl.layer_rule{ match = { namespace = "caelestia-drawers" }, ignore_alpha = 0.57 }

            hl.window_rule{ match = { class = "org.quickshell" }, opaque = true, float = true }
          '';
        };

        xdg.configFile = {
          "hypr/variables.conf" = {
            text = ''
              # ### Hyprland ###
              # Apps

              # Touchpad
              $touchpadDisableTyping = true
              $touchpadScrollFactor = 0.2
              $workSpaceSwipeFingers = 4

              # Blur
              $blurEnabled = true
              $blurSpecialWs = false
              $blurPopups = true
              $blurInputMethods = true
              $blurSize = 8
              $blurPasses = 4
              $blurXray = false

              # Shadow
              $shadowEnabled = true
              $shadowRange = 20
              $shadowRenderPower = 3
              $shadowColour = rgba($surfaced4)

              # Gaps
              $workspaceGaps = 20
              $windowGapsIn = 3
              $windowGapsOut = 6
              $singleWindowGapsOut = 20

              # Window styling
              $windowOpacity = 0.85
              $windowRounding = 10

              $windowBorderSize = 3
              $activeWindowBorderColour = rgba($primarye6)
              $inactiveWindowBorderColour = rgba($onSurfaceVariant11)

            '';
          };
        };

      })

    ]
  );

}
