{
  flake.modules.nixos."services.proxy" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.profiles.services.proxy.enable (lib.mkMerge [
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
      ]);

    };
}
