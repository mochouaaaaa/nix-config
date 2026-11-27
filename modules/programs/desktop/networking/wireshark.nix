{
  # Wireshark is temporarily disabled on macOS.
  flake.aspects."desktop.programs.networking"."darwin" = {
    homebrew.casks = [ "wireshark-app" ];
  };

  # Keep packet-capture permissions with the optional Wireshark feature.
  flake.aspects."desktop.programs.networking"."nixos" =
    { username, ... }:
    {
      programs.wireshark.enable = true;
      users.groups.wireshark = { };
      users.users.${username}.extraGroups = [ "wireshark" ];
    };
}
