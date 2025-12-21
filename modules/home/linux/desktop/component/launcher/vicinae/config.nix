{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.vicinae;
in
{

  config = lib.mkIf (cfg.enable) {

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
      autoStart = true;
      package = pkgs.vicinae;
      themes = {
        # base16-default-dark = {
        #   version = "1.0.0";
        #   appearance = "dark";
        #   # icon = /path/to/icon.png;
        #   name = "base16 default dark";
        #   description = "base16 default dark by Chris Kempson";
        #   palette = {
        #     background = "#181818";
        #     foreground = "#d8d8d8";
        #     blue = "#7cafc2";
        #     green = "#a3be8c";
        #     magenta = "#ba8baf";
        #     orange = "#dc9656";
        #     purple = "#a16946";
        #     red = "#ab4642";
        #     yellow = "#f7ca88";
        #     cyan = "#86c1b9";
        #   };
        # };
      };
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

    systemd.user.services.vicinae = lib.mkMerge [
      (lib.mkIf cfg.enable {
        Service = {
          Environment = [
            "QT_QPA_PLATFORMTHEME=gtk3"
          ];
        };
      })
    ];

  };
}
