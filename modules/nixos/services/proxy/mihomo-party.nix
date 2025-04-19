{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.modules.network.proxy.mihomo-party;
in
{

  options.modules.network.proxy.mihomo-party = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable mihomo-party proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${self.myvars.username}.packages = lib.mkAfter [ pkgs.mihomo-party ];
    security.wrappers.mihomo-party = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service,cap_net_admin=+ep";
      source = "${lib.getExe pkgs.mihomo-party}";
    };
  };
}
