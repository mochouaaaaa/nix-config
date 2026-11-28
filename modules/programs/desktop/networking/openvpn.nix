{
  # Tunnelblick is the macOS GUI client for OpenVPN.
  flake.aspects.desktop-programs.provides.networking.provides.openvpn.darwin = {
    homebrew.casks = [ "tunnelblick" ];
  };
}
