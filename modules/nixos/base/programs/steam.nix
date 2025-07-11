{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages.steam;
in
{
  options.modules.packages.steam = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Steam.";
    };
    monitor = mkOption {
      type = types.str;
      default = "DP-1";
      description = "The monitor to use for Steam.";
    };
    fps = mkOption {
      type = types.int;
      default = 60;
      description = "The maximum frames per second to render the game.";
      apply = x: toString x;
    };
    bg = mkOption {
      type = types.int;
      default = "";
      description = "The background image to use for Steam.";
      apply = x: toString x;
    };
  };

  config = lib.mkIf cfg.enable {

    hardware.steam-hardware.enable = true;

    # https://wiki.archlinux.org/title/steam
    # Games installed by Steam works fine on NixOS, no other configuration needed.
    programs.steam = {
      # Some location that should be persistent:
      #   ~/.local/share/Steam - The default Steam install location
      #   ~/.local/share/Steam/steamapps/common - The default Game install location
      #   ~/.steam/root        - A symlink to ~/.local/share/Steam
      #   ~/.steam             - Some Symlinks & user info
      enable = true;
      # https://github.com/ValveSoftware/gamescope
      # enables features such as resolution upscaling and stretched aspect ratios (such as 4:3)
      gamescopeSession.enable = true;

      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils

            # fix CJK fonts
            source-sans
            source-serif
            source-han-sans
            source-han-serif

            # audio
            pipewire

            # other common
            udev
            alsa-lib
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr # To use the x11 feature
            libxkbcommon
            wayland # To use the wayland feature
          ];
      };
    };

    environment.systemPackages = with pkgs; [
      linux-wallpaperengine
    ];

    systemd.user.services = {
      linux-wallpaperengine = {
        enable = true;
        description = "Wallpaper engine daemon";
        wantedBy = [ "graphical-session.target" ];
        unitConfig = {
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.linux-wallpaperengine} --scaling fill --screen-root ${cfg.monitor} --fps ${cfg.fps} --bg ${cfg.bg}";
          Restart = "on-failure";
        };
        environment = {
          XDG_SESSION_TYPE = "wayland";
          WAYLAND_DISPLAY = "wayland-1";
          GDK_BACKEND = "wayland";
          DISPLAY = ":0";
        };
      };
    };

    fonts.packages = with pkgs; [
      wqy_zenhei # Need by steam for Chinese
    ];

  };
}
