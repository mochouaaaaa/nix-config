{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules'.shortcuts;
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  options.modules'.shortcuts = {
    global = lib.mkOption rec {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Global shortcuts.";
      apply = userValue: default ++ userValue;
    };
  };

  config = lib.mkIf (config.programs.desktop.enable) {
    services.xremap = {
      enable = true;
      # serviceMode = "user";
      watch = true;
      # debug = true;
      withWlroots = false;
      withKDE = false;
      withGnome = false;
      withNiri = false;
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
        keymap = [
          {
            name = "Replace Super/Command With Ctrl";
            exact_match = true;
            application.not = [
              "kitty"
              "code"
            ];
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
