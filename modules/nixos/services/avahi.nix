{ lib, config, ... }:
{

  config = lib.mkIf (!config.profiles.wsl.enable) {

    # Network discovery, mDNS
    # With this enabled, you can access your machine at <hostname>.local
    # it's more convenient than using the IP address.
    # https://avahi.org/
    services.avahi = {
      enable = true;
      nssmdns4 = true;

      settings.publish = {
        "disable-publishing" = false;
        "publish-domain" = true;
        "disable-user-service-publishing" = false;
        "publish-addresses" = true;
      };
    };

    # Use an NTP server located in the mainland of China to synchronize the system time
    networking.timeServers = [
      "ntp.aliyun.com" # Aliyun NTP Server
      "ntp.tencent.com" # Tencent NTP Server
    ];

  };
}
