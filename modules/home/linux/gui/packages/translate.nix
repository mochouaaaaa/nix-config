{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages;
in
{
  options.modules.packages = {
    translate.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable translate.";
    };
  };

  config = lib.mkIf cfg.translate.enable {

    home.packages = with pkgs; [
      pot
      grimblast
      tesseract
    ];

    xdg.configFile."autostart/pot-app.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        Name=pot
        Comment=potstartup script
        Exec=${pkgs.pot}/bin/pot
        StartupNotify=false
        Terminal=false
      '';
    };

    modules.shortcuts.global = lib.mkAfter [
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
              if grimblast --freeze save area ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png; then
                  curl "127.0.0.1:60828/ocr_translate?screenshot=false"
              fi
            ''
          ];
        };
      }
    ];

  };
}
