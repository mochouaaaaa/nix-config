{
  lib,
  pkgs,
  config,
  pkgs-stable,
  ...
}:
let
  cfg = config.profiles.packages.live;
  isDesktop = config.profiles.desktop.enable;
in
{
  options.profiles.packages.live = {
    obs.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable OBS Studio and related creative/FPGA tools.";
    };
    iptv.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable IPTV (Hypnotix).";
    };
    simple-live-app.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Simple Live App.";
    };
    wiliwili.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Wiliwili (BiliBili Client).";
    };
  };

  config = lib.mkIf isDesktop (
    lib.mkMerge [
      # OBS Studio and other creative packages
      (lib.mkIf cfg.obs.enable {
        home.packages = with pkgs; [
          kooha # 录制屏幕 GIF图
          # creative
          # blender # 3d modeling
          # inkscape # vector graphics
          # krita # PS digital painting
          # musescore # music notation
        ];

        programs.obs-studio = {
          enable = true;
          package = pkgs-stable.obs-studio;
          plugins = with pkgs-stable.obs-studio-plugins; [
            wlrobs
            distroav
            obs-vaapi
            obs-teleport
            obs-hyperion
            droidcam-obs
            obs-vkcapture
            obs-gstreamer
            obs-3d-effect
            obs-multi-rtmp
            obs-source-clone
            obs-shaderfilter
            obs-source-record
            obs-livesplit-one
            looking-glass-obs
            obs-vintage-filter
            obs-command-source
            obs-move-transition
            obs-backgroundremoval
            advanced-scene-switcher
            obs-pipewire-audio-capture
          ];
        };
      })

      # Other live packages
      {
        home.packages =
          [ ]
          ++ lib.optionals cfg.iptv.enable [ pkgs.hypnotix ]
          ++ lib.optionals cfg.simple-live-app.enable [ pkgs.simple-live-app ]
          ++ lib.optionals cfg.wiliwili.enable [ pkgs.piliplus ];
      }
    ]
  );
}
