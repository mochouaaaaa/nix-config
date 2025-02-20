{pkgs, ...}: {
  # Linux Only Packages, not available on Darwin
  home.packages = with pkgs; [
    # misc
    libnotify
    mitmproxy # http/https proxy tool
    wireguard-tools # manage wireguard vpn manually, via wg-quick

    ventoy # create bootable usb
    persepolis
  ];
}
