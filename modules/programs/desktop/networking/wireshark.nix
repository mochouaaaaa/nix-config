{
  # Wireshark is temporarily disabled on macOS.
  flake.modules.darwin."desktop.programs.networking" = {
    homebrew.casks = [ "wireshark-app" ];
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
