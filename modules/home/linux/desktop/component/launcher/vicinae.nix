{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.services.vicinae;
in
{

  imports = [ inputs.vicinae.homeManagerModules.default ];

  options.modules'.desktop.services.vicinae = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Vicinae service";
    };
  };

  config = lib.mkIf cfg.enable {

    modules'.shortcuts.global = [
      {
        "SUPER-SPACE" = {
          launch = [
            "bash"
            "-c"
            "vicinae toggle"
          ];
        };
        "SUPER-p" = {
          launch = [
            "bash"
            "-c"
            "vicinae vicinae://extensions/vicinae/clipboard/history"
          ];
        };
      }
    ];

    services.vicinae = {
      enable = true;
      autoStart = true;
      package = pkgs.vicinae;
      settings = {
        closeOnFocusLoss = true;
        faviconService = "google";
        font = {
          size = 12;
          normal = "Monaco Nerd Font";
        };
        keybinding = "default";
        keybinds = { };
        popToRootOnClose = true;
        rootSearch = {
          searchFiles = true;
        };
        theme = {
          name = "matugen";
          iconTheme = "WhiteSur-light";
        };
        window = {
          csd = true;
          opacity = 0.78;
          rounding = 10;
        };
      };
    };

    xdg.configFile."vicinae/vicinae.json".force = true;

    systemd.user.services.vicinae = {
      Service = {
        Environment = [
          "QT_QPA_PLATFORMTHEME=gtk3"
        ];
      };
    };

  };

}
