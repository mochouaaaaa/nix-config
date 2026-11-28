{
  # Wireshark is temporarily disabled on macOS.
  flake.aspects."desktop.programs".provides.networking.provides.wireshark."darwin" = {
    homebrew.casks = [ "wireshark-app" ];
  };

  # Keep packet-capture permissions with the optional Wireshark feature.
  flake.aspects."desktop.programs".provides.networking.wireshark.nixos =
    { username, ... }:
    {
      programs.wireshark.enable = true;
      users.groups.wireshark = { };
      users.users.${username}.extraGroups = [ "wireshark" ];
    };
}
