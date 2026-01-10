{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{

  config = lib.mkIf cfg.enable {

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

      slurp
      gimp
      grim
      grimblast

      # audio
      # pkgs-stable.networkmanagerapplet # provide GUI app: nm-connection-editor
    ];

  };
}
