{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.network.proxy.clash-party;
in
{
  options.modules'.network.proxy.clash-party = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable clash-party proxy.";
    };
  };

  config = lib.mkIf (config.programs.desktop.enable && cfg.enable) {

    modules'.persistent.hmDirectories = [
      # mihomo party
      ".config/mihomo"
      ".config/mihomo-party"
      ".config/pulse"
      ".local/state/wireplumber"
    ];

    environment = {
      systemPackages = with pkgs; [
        clash-party
        (makeAutostartItem {
          name = "clash-party";
          package = pkgs.clash-party;
        })
      ];
    };

    security.wrappers.clash-party = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin=+ep";
      source = "${lib.getExe pkgs.clash-party}";
    };

  };
}
