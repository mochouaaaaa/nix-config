{
  flake.modules.nixos."services.proxy" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkMerge [
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
      ];

    };
}
