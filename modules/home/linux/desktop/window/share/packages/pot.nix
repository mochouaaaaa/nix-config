{
  lib,
  pkgs,
  pkgs-stable,
  config,
  ...
}:
{
  config = lib.mkIf (config.programs.desktop.enable) {

    # home.packages = with pkgs-stable; [
    #   pot
    #   pkgs.grimblast
    #   tesseract
    # ];

    # systemd.user.services.pot = {
    #   Unit = {
    #     Description = "Pot translation daemon";
    #     After = [ config.wayland.systemd.target ];
    #   };
    #   Service = {
    #     ExecStart = "${lib.getExe pkgs-stable.pot}";
    #     Restart = "on-failure";
    #   };
    #   Install = {
    #     WantedBy = [ config.wayland.systemd.target ];
    #   };
    # };

    # modules'.shortcuts.global = [
    #   {
    #     "ALT-a" = {
    #       launch = [
    #         "curl"
    #         "127.0.0.1:60828/input_translate"
    #       ];
    #     };
    #     "ALT-d" = {
    #       launch = [
    #         "curl"
    #         "127.0.0.1:60828/selection_translate"
    #       ];
    #     };
    #     "ALT-s" = {
    #       launch = [
    #         "bash"
    #         "-c"
    #         ''
    #           rm -f ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png
    #           mkdir -p ~/.cache/com.pot-app.desktop
    #           if grimblast --freeze save area ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png; then
    #               curl "127.0.0.1:60828/ocr_translate?screenshot=false"
    #           fi
    #         ''
    #       ];
    #     };
    #   }
    # ];

  };
}
