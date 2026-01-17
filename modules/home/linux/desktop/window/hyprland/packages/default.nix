{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{

  config = lib.mkIf cfg.enable {

    programs.quickshell = {
      enable = true;
      systemd.enable = true;
    };

    programs = {
      swappy = {
        enable = true;
        settings = {
          Default = {
            save_dir = "$XDG_PICTURES_DIR/Screenshots";
          };
        };
      };
    };

    home.packages = with pkgs; [

      inputs.hyprshutdown.packages.${pkgs.stdenv.hostPlatform.system}.hyprshutdown

      slurp
      gimp
      grim
      grimblast
    ];

  };
}
