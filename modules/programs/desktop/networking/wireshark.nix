{
  flake.aspects."desktop.programs".provides.networking.provides.wireshark = {
    nixos =
      { pkgs, username, ... }:
      {
        programs.wireshark.enable = true;
        environment.systemPackages = [ pkgs.wireshark-cli ];
        users.groups.wireshark = { };
        users.users.${username}.extraGroups = [ "wireshark" ];
      };

    # Wireshark's GUI package is temporarily disabled on macOS.
    darwin = {
      homebrew.casks = [ "wireshark-app" ];
    };
  };
}
