{
  flake.modules.nixos.core = {

    # Use an NTP server located in the mainland of China to synchronize the system time
    networking.timeServers = [
      "ntp.aliyun.com" # Aliyun NTP Server
      "ntp.tencent.com" # Tencent NTP Server
    ];

  };
}
