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
          blender # 3d modeling
          inkscape # vector graphics
          krita # digital painting
          musescore # music notation
          go-musicfox
          # fpga
          pkgs-stable.python312Packages.apycula # gowin fpga
          pkgs-stable.yosys # fpga synthesis
          pkgs-stable.nextpnr # fpga place and route
          pkgs-stable.openfpgaloader # fpga programming
        ];

        programs.obs-studio = {
          enable = true;
          package = pkgs-stable.obs-studio;
          plugins = with pkgs-stable.obs-studio-plugins; [
            wlrobs
            # obs-ndi
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
      (
        let
          wiliwili-pkg = pkgs.wiliwili.overrideAttrs (oldAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = "xfangfang";
              repo = "wiliwili";
              rev = "v1.5.3";
              fetchSubmodules = true;
              hash = "sha256-NPJ1PLO6eqm4rBn4t965S0lqzT+npfYLWN6FKYCpnlQ=";
            };
          });
        in
        {
          home.packages =
            [ ]
            ++ lib.optionals cfg.iptv.enable [ pkgs.hypnotix ]
            ++ lib.optionals cfg.simple-live-app.enable [ pkgs.simple-live-app ]
            ++ lib.optionals cfg.wiliwili.enable [ pkgs.piliplus ];
        }
      )
    ]
  );
}
