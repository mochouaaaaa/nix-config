{
  flake.modules.nixos.core = {
    # Use mainland China NTP servers for system time synchronization.
    networking.timeServers = [
      "ntp.aliyun.com"
      "ntp.tencent.com"
    ];
  };
}
