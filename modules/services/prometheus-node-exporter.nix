{
  flake.aspects."services.prometheus.node-exporter"."nixos" = {
    services.prometheus.exporters.node = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = 9100;
      openFirewall = true;
      enabledCollectors = [
        "systemd"
        "logind"
      ];
    };
  };
}
