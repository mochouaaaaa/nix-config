{
  # Tunnelblick is the macOS GUI client for OpenVPN.
  flake.aspects."desktop.programs".provides.networking.openvpn."darwin" = {
    homebrew.casks = [ "tunnelblick" ];
  };
}
