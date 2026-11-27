{
  flake.aspects.core.provides.networking.nixos = {
    # Use mainland China NTP servers for system time synchronization.
    networking.timeServers = [
      "ntp.aliyun.com"
      "ntp.tencent.com"
    ];
  };
}
