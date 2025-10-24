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
        };
        keybinding = "default";
        keybinds = { };
        popToRootOnClose = true;
        rootSearch = {
          searchFiles = true;
        };
        theme = {
          name = "matugen";
        };
        window = {
          csd = true;
          opacity = 0.78;
          rounding = 10;
        };
      };
    };

    xdg.configFile = {
      "vicinae/vicinae.json".enable = false;
    };

    home.activation =
      let
        json = pkgs.formats.json { };
        data = json.generate "vicinae.json" config.services.vicinae.settings;
      in
      {
        initVicinae = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          rm -rf ${config.xdg.configHome}/vicinae/vicinae.*
          cat ${data} > ${config.xdg.configHome}/vicinae/vicinae.json
        '';
      };

  };

}
