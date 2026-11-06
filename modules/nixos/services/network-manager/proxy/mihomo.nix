{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.services.proxy;
in
{

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.mihomo = {
          enable = true;
          webui = pkgs.metacubexd;
          configFile = ./mihomo.yaml;
          processesInfo = true;
        };
      }

      (lib.mkIf config.services.mihomo.tunMode {
        networking.firewall.checkReversePath = lib.mkDefault "loose";
      })
    ]
  );

}
