{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.network.proxy.clash;
in
{

  options.profiles.network.proxy.clash = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Clash proxy.";
    };
  };

  config = lib.mkIf (config.profiles.desktop.enable && cfg.enable) {

    profiles.persistent.hmDirectories = [
      ".local/share/io.github.clash-verge-rev.clash-verge-rev"
      ".local/share/clash-verge"
    ];

    programs.clash-verge = {
      enable = true;
      autoStart = true;
      # serviceMode = true;
      # tunMode = true;
    };
  };
}
