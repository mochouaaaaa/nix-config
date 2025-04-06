{
  self,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.ollama;
in
{
  options.modules.packages.ollama = {
    enable = lib.mkEnableOption "ollama";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };
  };
}
