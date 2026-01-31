{
  lib,
  config,
  ...

}:
let
  cfg = config.programs.noctalia-shell;
in
{

  config = lib.mkIf (cfg.enable) {

    programs.noctalia-shell = {
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          screen-recorder = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          privacy-indicator = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          todo = {
            enabled = false;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 1;
      };
      pluginSettings = {
        privacy-indicator = {
          hideInactive = true;
          iconSpacing = 9;
          removeMargins = 9;
        };
        screen-recorder = {
          audioCodec = "opus";
          audioSource = "default_output";
          colorRange = "limited";
          copyToClipboard = false;
          directory = "${config.home.homeDirectory}/Videos/Recordings";
          filenamePattern = "recording_yyyyMMdd_HHmmss";
          frameRate = "60";
          quality = "very_high";
          showCursor = true;
          videoCodec = "h264";
          videoSource = "portal";
        };
      };

    };

  };
}
