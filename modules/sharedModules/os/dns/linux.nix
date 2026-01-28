{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.services.dns;
  formatYaml = pkgs.formats.yaml { };
in
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {

    profiles.services.dns.enable = true;

    networking = {
      networkmanager.dns = lib.mkForce "none";
      nameservers = lib.mkForce [
        "127.0.0.1"
      ];
      resolvconf.enable = true;
    };

    systemd.services.mosdns =
      let
        mosdns_config = formatYaml.generate "mosdns.yaml" cfg.settings;

        args = lib.concatStringsSep " " [
          "-d /var/lib/mosdns/"
          "-c /var/lib/mosdns/config.yaml"
        ];
      in
      {
        description = "mosdns: Network-level blocker";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        unitConfig = {
          StartLimitIntervalSec = 5;
          StartLimitBurst = 10;
        };

        preStart = lib.optionalString (cfg.settings != null) ''
          TEMP_FILE=$(mktemp)
          ${pkgs.gnused}/bin/sed -E 's/\$([^{])/$$\1/g' ${mosdns_config} > "$TEMP_FILE"
          ${lib.getExe pkgs.envsubst} < "$TEMP_FILE" > "$STATE_DIRECTORY/config.yaml"
          chmod 644 "$STATE_DIRECTORY/config.yaml"
        '';

        serviceConfig = {
          DynamicUser = true;
          EnvironmentFile = config.age.secrets.next_dns_server.path;
          ExecStart = "${lib.getExe cfg.package} start ${args}";
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          Restart = "always";
          RestartSec = 10;

          RuntimeDirectory = "mosdns";
          StateDirectory = "mosdns";
          StandardOutput = "append:/var/log/mosdns.log";
          StandardError = "inherit";
        };
      };

    networking.firewall.allowedTCPPorts =
      let
        enable_tcp = lib.hasAttrByPath [ "api" "http" ] cfg.settings;
        split_port = if enable_tcp then lib.strings.split ":" cfg.settings.api.http else [ ];
        port = if (lib.lists.length split_port > 0) then builtins.fromJSON (lib.last split_port) else 0;
      in
      lib.optionals (port > 0) [ port ];

  };

}
