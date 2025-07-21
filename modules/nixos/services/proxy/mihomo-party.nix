{
  config,
  lib,
  pkgs,
  username,
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

    environment = {
      systemPackages = with pkgs; [
        mihomo-party-wrapper
        (makeAutostartItem {
          name = "mihomo-party";
          package = pkgs.mihomo-party-wrapper;
        })
      ];
    };

    # systemd.services.mihomo-party = {
    #   enable = true;
    #   description = "mihomo daemon";
    #   wantedBy = [ "graphical.target" ];
    #   unitConfig = {
    #     After = [ "graphical.target" ];
    #     PartOf = [ "graphical.target" ];
    #   };
    #   serviceConfig = {
    #     ExecStart = "${lib.getExe pkgs.mihomo-party-wrapper}";
    #     Restart = "on-failure";
    #     CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW";
    #     AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW";
    #     NoNewPrivileges = false;
    #   };
    #   environment = {
    #     XDG_SESSION_TYPE = "wayland";
    #     GDK_BACKEND = "wayland";
    #     DISPLAY = ":0";
    #   };
    # };

    security.wrappers.mihomo-party = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin=+ep";
      source = "${lib.getExe pkgs.mihomo-party-wrapper}";
    };

  };
}
