{
  # Tunnelblick is the macOS GUI client for OpenVPN.
  flake.aspects."desktop.programs.networking"."darwin" = {
    homebrew.casks = [ "tunnelblick" ];
  };
}
