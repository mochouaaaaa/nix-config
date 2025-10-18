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
      settings = {
        closeOnFocusLoss = true;
        faviconService = "twenty";
        font = {
          size = 12;
        };
        keybinding = "default";
        keybinds = { };
        popToRootOnClose = true;
        rootSearch = {
          searchFiles = true;
        };
        extensions = [
          # (pkgs.mkVicinaeExtension {
          #   inherit pkgs;
          #   name = "github";
          #   src = pkgs.fetchFromGitHub{
          #           owner = "raycast";
          #           repo = "extensions";
          #
          #       };
          # })
        ];
        theme = {
          name = "vicinae-dark";
        };
        window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };
  };

}
