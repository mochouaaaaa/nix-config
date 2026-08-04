{ lib, ... }:
{

  networking = {
    # desktop need its cli for status bar
    networkmanager = {
      enable = true;
      ensureProfiles = {
        profiles = {
          home-wifi = {
            connection = {
              type = "wifi";
              id = "TP-LINK-TEST";
              permissions = "";
            };
            wifi = {
              ssid = "TP-LINK-TEST";
              mode = "infrastructure";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$HOME_WIFI_PASSWORD";
            };

            ipv4.method = "auto";
            ipv6.method = "auto";
          };
          wifi-backup = {
            connection = {
              id = "CMCC-3QZ6-5G";
              type = "wifi";
              autoconnect = true;
              autoconnect-priority = 50;
              autoconnect-retries = 0;
            };

            wifi = {
              mode = "infrastructure";
              ssid = "Backup-WiFi";
            };

            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "5cedyz5h";
            };

            ipv4.method = "auto";
            ipv6.method = "auto";
          };
        };
      };
    };
    useDHCP = lib.mkForce false;
    dhcpcd.enable = false;

    interfaces.enp6s0.useDHCP = lib.mkForce true;
    interfaces.wlp5s0.useDHCP = lib.mkForce true;
    # networkmanager.wifi.scanRandMacAddress = true;

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];

  };

}
