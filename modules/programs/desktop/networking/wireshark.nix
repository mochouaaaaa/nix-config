{
  # Wireshark is temporarily disabled on macOS.
  flake.aspects."desktop.programs".provides.networking.provides.wireshark."darwin" = {
    homebrew.casks = [ "wireshark-app" ];
  };
}
