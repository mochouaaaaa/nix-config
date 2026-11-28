{
  # Wireshark is temporarily disabled on macOS.
  flake.aspects."desktop.programs".provides.networking.provides.wireshark."darwin" = {
    homebrew.casks = [ "wireshark-app" ];
  };

  # The host imports the networking aspect directly, so keep the NixOS
  # Wireshark configuration on that aspect rather than an un-included child.
  flake.aspects."desktop.programs".provides.networking.nixos =
    { pkgs, username, ... }:
    {
      programs.wireshark.enable = true;
      environment.systemPackages = [ pkgs.wireshark-cli ];
      users.groups.wireshark = { };
      users.users.${username}.extraGroups = [ "wireshark" ];
    };
}
