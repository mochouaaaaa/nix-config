{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.packages.ollama;
in
{
  options.profiles.packages.ollama = {
    enable = lib.mkEnableOption "ollama";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };
  };
}
