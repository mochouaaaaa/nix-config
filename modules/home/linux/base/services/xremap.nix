{
  self,
  lib,
  inputs,
  config,
  ...
}:
let
  cfgDesktop = config.modules.desktop;
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  services.xremap = {
    enable = true;
    watch = true;
    # debug = true;
    withWlroots = cfgDesktop.niri.enable || cfgDesktop.hyprland.enable;
    withKDE = cfgDesktop.kde.enable;
    withGnome = cfgDesktop.gnome.enable;
    config = {
      modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Esc";
          }; # globally remap CapsLock to Esc
        }
      ];
      keymap = [
        {
          name = "Shortcuts";
          exact_match = true;
          remap = lib.mkMerge (
            [
              { }
            ]
            ++ lib.optionals (cfgDesktop.hyprland.enable || cfgDesktop.niri.enable) [
              {
                "ALT-a" = {
                  launch = [
                    "curl"
                    "127.0.0.1:60828/input_translate"
                  ];
                };
                "ALT-d" = {
                  launch = [
                    "curl"
                    "127.0.0.1:60828/selection_translate"
                  ];
                };
                "ALT-s" = {
                  launch = [
                    "bash"
                    "-c"
                    ''
                      rm -f ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png
                      if grim -g "$(slurp)" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png; then
                          curl "127.0.0.1:60828/ocr_translate?screenshot=false"
                      fi
                    ''
                  ];
                };
              }
            ]
          );
        }
        {
          name = "Replace Super/Command With Ctrl";
          exact_match = true;
          application.not = [ "kitty" ];
          remap = {
            "SUPER-c" = "C-c";
            "SUPER-v" = "C-v";
            "SUPER-x" = "C-x";
            "SUPER-w" = "C-w";
            "SUPER-a" = "C-a";
            "SUPER-z" = "C-z";
            "SUPER-t" = "C-t";
            "SUPER-f" = "C-f";
            "SUPER-r" = "C-r";
          };
        }
      ];
    };
  };
}
