{
  # Tunnelblick is the macOS GUI client for OpenVPN.
  flake.modules.darwin."desktop.programs.networking" = {
    homebrew.casks = [ "tunnelblick" ];
  };
}
