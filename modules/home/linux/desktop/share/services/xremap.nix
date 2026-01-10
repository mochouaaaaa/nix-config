{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.profiles.shortcuts;
  cfgDesktop = config.profiles.desktop;
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  options.profiles.shortcuts = {
    global = lib.mkOption rec {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Global shortcuts.";
      apply = userValue: default ++ userValue;
    };
  };

  config = lib.mkIf (config.profiles.desktop.enable) {
    services.xremap = {
      enable = true;
      watch = true;
      # debug = true;
      withWlroots = cfgDesktop.hyprland.enable;
      withKDE = cfgDesktop.kde.enable;
      withGnome = cfgDesktop.gnome.enable;
      withNiri = cfgDesktop.niri.enable;
      withHypr = false;
      config = {
        modmap = [
          {
            name = "Global";
            remap = {
              "CapsLock" = "Esc";
              "Esc" = "CapsLock";
            }; # globally remap CapsLock to Esc
          }
        ];
        keymap =
          let
            zen = {
              "SUPER-c" = "C-c";
              "SUPER-v" = "C-v";
              "SUPER-x" = "C-x";
              "SUPER-a" = "C-a";
              "SUPER-z" = "C-z";
            };
          in
          [
            {
              name = "Replace Super/Command With Ctrl";
              exact_match = true;
              application.only = [
                "firefox"
                "chromium"
                "zen"
                "zen-beta"
              ];
              remap = zen;
            }
            {
              name = "Firefox/Chromium Replace Super/Command With Ctrl";
              exact_match = true;
              application.only = [
                "firefox"
                "chromium"
              ];
              remap = {
                "SUPER-r" = "C-r";
                "SUPER-f" = "C-f";
                "SUPER-w" = "C-w";
                "SUPER-t" = "C-t";
              };
            }
          ]
          ++ (lib.optionals ((lib.lists.length cfg.global) > 0)) [
            {
              name = "Shortcuts";
              exact_match = true;
              remap = lib.mkMerge (cfg.global);
            }
          ];
      };
    };
  };
}
