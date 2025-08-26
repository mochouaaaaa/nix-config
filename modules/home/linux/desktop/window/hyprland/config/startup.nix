{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;

  # swww = inputs.swww.packages.${pkgs.system}.swww;
in
{
  config = lib.mkIf cfg.enable {

    services.network-manager-applet.enable = true;
    modules'.desktop.services.cliphist.enable = true;
    modules'.desktop.services.polkitagent.enable = true;

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"

          #"${swww}/bin/swww-daemon --format xrgb"
          #"${swww}/bin/swww img $HOME/.current_wallpaper"
          #"${lib.getExe pkgs.pywal16} -i $HOME/.current_wallpaper"
        ];
      };
    };
  };
}
