{
  # system.defaults.smb.NetBIOSName = hostname;

  networking = {
    # hostName = hostname;
    computerName = "mochou’s MacBook Pro";
    knownNetworkServices = [
      "Wi-Fi"
      "Ethernet Adaptor"
      "Thunderbolt Ethernet"
      "Thunderbolt Bridge"
    ];
    dns = [
      "223.5.5.5"
      "2001:4860:4860::8888"
      "2606:4700:4700::1111"
    ];
  };
}
