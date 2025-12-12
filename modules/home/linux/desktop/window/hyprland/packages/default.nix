{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  imports = lib.importModule' ./.;

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
      alsa-utils # provides amixer/alsamixer/...
      pkgs-stable.mpd # for playing system sounds
      pkgs-stable.mpc-cli # command-line mpd client
      pkgs-stable.ncmpcpp # a mpd client with a UI
      pkgs-stable.networkmanagerapplet # provide GUI app: nm-connection-editor
    ];

  };
}
