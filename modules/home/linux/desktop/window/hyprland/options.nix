{
  lib,
  pkgs,
  ...
}:
{
  options.profiles.desktop.hyprland = {
    settings = {
      media = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default =
          let
            playerctl = "${lib.getExe pkgs.playerctl}";
          in
          [
            ", XF86AudioPlay, exec, ${playerctl} play-pause"
            ", XF86AudioStop, exec, ${playerctl} pause"
            ", XF86AudioPrev, exec, ${playerctl} previous"
            ", XF86AudioNext, exec, ${playerctl} next"
            ", XF86audioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];
      };
      brightness = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      volume = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ", XF86Audioraisevolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86Audiolowervolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
      };
      shell-settings = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      lock = lib.mkOption {
        type = lib.types.str;
        default = "hyprlock";
      };
      clipboard = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      launcher = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      screenshot = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "$mod CTRL, S, exec, grimblast -n -o -e 5000 --freeze copysave active"
          "$mod CTRL, A, exec, grimblast -n -o -e 5000 --freeze copysave area"
        ];
      };
    };
  };
}
