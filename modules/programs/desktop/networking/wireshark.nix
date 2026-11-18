{
  # Wireshark is temporarily disabled on macOS.
  flake.modules.darwin."desktop.programs.networking" = {
    homebrew.casks = [ "wireshark-app" ];
  };

  # Keep packet-capture permissions with the optional Wireshark feature.
  flake.modules.nixos."desktop.programs.networking" =
    { username, ... }:
    {
      programs.wireshark.enable = true;
      users.groups.wireshark = { };
      users.users.${username}.extraGroups = [ "wireshark" ];
    };
}
