{ ... }:
{
  flake.aspects = { aspects, ... }: {
    services.provides.dns.mosdns = {
      includes = [
        aspects.services._.dns
      ];

      nixos =
        {
          lib,
          pkgs,
          config,
          ...
        }:
        let
          formatYaml = pkgs.formats.yaml { };

          cfg = config.profiles.services.dns.mosdns;
          cfgDNS = config.profiles.services.dns;
        in
        {
          options.profiles.services.dns.mosdns = {
            webapi = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1:8338";
            };

            settings = lib.mkOption {
              default = { };
              description = "Structured plugin lists for mosdns.";
              type = lib.types.submodule {
                freeformType = formatYaml.type;

                options =
                  let
                    mkPluginListOption =
                      description:
                      lib.mkOption {
                        type = with lib.types; listOf attrs;
                        default = [ ];
                        inherit description;
                      };
                  in
                  {
                    rules = mkPluginListOption "DNS matching and routing rules.";
                    upstreams = mkPluginListOption "Upstream DNS servers and forwarding targets.";
                    cache-ecs = mkPluginListOption "Cache and EDNS Client Subnet (ECS) plugins.";
                    fallback = mkPluginListOption "Fallback plugins.";
                    sequences = mkPluginListOption "Named execution sequences.";
                    query = mkPluginListOption "Query-stage processing plugins.";
                    filters = mkPluginListOption "Domain, IP, or query/response filter plugins.";
                    response = mkPluginListOption "Response-stage processing plugins.";
                    pre_sequence = mkPluginListOption "Pre-sequence processing plugins.";

                    plugins = lib.mkOption {
                      type = with lib.types; listOf attrs;
                      default = lib.concatLists [
                        cfg.settings.rules
                        cfg.settings.upstreams
                        cfg.settings.cache-ecs
                        cfg.settings.fallback
                        cfg.settings.sequences
                        cfg.settings.query
                        cfg.settings.filters
                        cfg.settings.response
                        cfg.settings.pre_sequence
                        [
                          {
                            type = "udp_server";
                            args = {
                              entry = "sequence";
                              inherit (cfgDNS) listen;
                            };
                          }
                          {
                            type = "tcp_server";
                            args = {
                              entry = "sequence";
                              inherit (cfgDNS) listen;
                            };
                          }
                        ]
                      ];
                      readOnly = true;
                      description = "Effective DNS listen address.";
                    };
                  };
              };
            };
          };

          config =
            let
              mosdnsSettings = {
                # api = {
                #   http = "${cfg.webapi}";
                # };
                log = {
                  level = "warn";
                  production = false;
                };
                plugins = cfg.settings.plugins;
              };
            in
            {
              networking.firewall.allowedTCPPorts = [ 8335 ];

              systemd.services.mosdns =
                let
                  modsndYaml = formatYaml.generate "mosdns.yaml" mosdnsSettings;

                  args = lib.concatStringsSep " " [
                    "-d /var/lib/mosdns/"
                    "-c /var/lib/mosdns/config.yaml"
                  ];
                in
                {
                  description = "mosdns: Network-level blocker";
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

                    template = Path("${modsndYaml}")
                    output = Path(state_dir) / "config.yaml"

                    content = template.read_text()
                    content = Template(content).safe_substitute(**envs)

                    output.write_text(content)
                    output.chmod(0o644)
                  ''}";

                  serviceConfig = {
                    DynamicUser = true;
                    ExecStart = "${lib.getExe pkgs.mosdns} start ${args}";
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
                  after = [ "network.target" ];
                  before = [ "nss-lookup.target" ];
                  wants = [ "nss-lookup.target" ];
                  wantedBy = [ "multi-user.target" ];
                };
            };
        };
    };
  };
}
