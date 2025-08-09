{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.network.proxy.mihomo-party;
in
{
  options.modules'.network.proxy.mihomo-party = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable mihomo-party proxy.";
    };
  };

  config = lib.mkIf cfg.enable {

    environment = {
      systemPackages = with pkgs; [
        mihomo-party-wrapper
        (makeAutostartItem {
          name = "mihomo-party";
          package = pkgs.mihomo-party-wrapper;
        })
      ];
    };

    security.wrappers.mihomo-party = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin=+ep";
      source = "${lib.getExe pkgs.mihomo-party-wrapper}";
    };

  };
}
