{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules.shortcuts;
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  options.modules.shortcuts = {
    global = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ { } ];
      description = "Global shortcuts.";
    };
  };

  config = {

    services.xremap = {
      enable = true;
      watch = true;
      # debug = true;
      withWlroots = false;
      withKDE = false;
      withGnome = false;
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
            remap = lib.mkMerge (cfg.global);
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
  };
}
