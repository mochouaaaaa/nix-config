{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.steam;
in
{
  options.modules'.packages.steam = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Steam.";
    };
  };

  config = lib.mkIf (cfg.enable && config.programs.desktop.enable) {

    modules'.persistent.hmDirectories = [
      # ======================================
      # Game
      # ======================================
      ".local/share/Steam"
      ".steam"
    ];

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
      gamescopeSession.enable = false;

      fontPackages = [ pkgs.wqy_zenhei ];

      protontricks = {
        enable = true;
      };

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

  };
}
