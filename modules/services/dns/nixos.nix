{

  flake.modules.nixos."services.dns" =
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

          preStart = "${pkgs.writeScript "config-generator" ''
            #!${pkgs.python3}/bin/python3
            import os
            from pathlib import Path
            from string import Template

            envs = os.environ

            state_dir = envs.get("STATE_DIRECTORY")
            if not state_dir:
                raise SystemExit("STATE_DIRECTORY is not set")

            template = Path("${mosdns_config}")
            output = Path(state_dir) / "config.yaml"

            content = template.read_text()
            content = Template(content).safe_substitute(**envs)

            output.write_text(content)
            output.chmod(0o644)
          ''}";

          serviceConfig = {
            DynamicUser = true;
            ExecStart = "${lib.getExe cfg.package} start ${args}";
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
            Restart = "always";
            RestartSec = 10;

            RuntimeDirectory = "mosdns";
            StateDirectory = "mosdns";
            StateDirectoryMode = "0700";
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
