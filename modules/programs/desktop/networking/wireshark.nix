{
  # macOS installs Wireshark as a per-user GUI application. On NixOS, use the
  # system module so packet-capture capabilities and group permissions are set
  # up by NixOS rather than relying on a Home Manager package alone.
  flake.modules.homeManager."desktop.programs.networking" =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        pkgs.wireshark
      ];
    };

  flake.modules.nixos."desktop.programs.networking" =
    { username, ... }:
    {
      programs.wireshark.enable = true;
      users.users.${username}.extraGroups = [ "wireshark" ];
    };
}
