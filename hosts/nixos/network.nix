{ lib, config, ... }:
{

  networking = {
    # desktop need its cli for status bar
    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [
          "${config.age.secrets.home_wifi_pwd.path}"
        ];
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
