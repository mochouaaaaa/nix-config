{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.nautilus".nixos = { pkgs, ... }: {
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      services = {
        dbus.packages = [ pkgs.mission-center ];
        gnome = {
          sushi.enable = true;
          gnome-settings-daemon.enable = true;
          glib-networking.enable = true;
        };
        tumbler.enable = true;
        gvfs.enable = true;
      };

      environment = {
        systemPackages = with pkgs; [
          turtle
          code-nautilus
          nautilus
          mission-center
          ffmpegthumbnailer
          ffmpeg-headless
        ];
        sessionVariables.ADW_DISABLE_PORTAL = 1;
        pathsToLink = [ "share/thumbnailers" ];
      };
    };

    "desktop.hyprland".includes = [ aspects."desktop.nautilus" ];
    "desktop.niri".includes = [ aspects."desktop.nautilus" ];
  };
}
