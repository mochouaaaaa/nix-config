{
  # Wireshark is temporarily disabled on macOS.
  flake.modules.homeManager."desktop.programs.networking" = { ... }: {
    home.packages = [ ];
  };

  # On NixOS, use the system module so packet-capture capabilities and group
  # permissions are configured by NixOS.
  flake.modules.nixos."desktop.programs.networking" =
    { username, ... }:
    {
      programs.wireshark.enable = true;
      users.users.${username}.extraGroups = [ "wireshark" ];
    };
}
