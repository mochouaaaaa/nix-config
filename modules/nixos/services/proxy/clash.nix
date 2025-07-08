{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.network.proxy.clash;
in
{
  options.modules.network.proxy.clash = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Clash proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
    };
  };
}
