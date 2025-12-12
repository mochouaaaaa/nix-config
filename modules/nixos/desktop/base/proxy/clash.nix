{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.network.proxy.clash;
in
{

  options.modules'.network.proxy.clash = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Clash proxy.";
    };
  };

  config = lib.mkIf (config.programs.desktop.enable && cfg.enable) {

    modules'.persistent.hmDirectories = [
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
