{ self, ... }:
let
  hostname = "macos";
in
{

  imports = [ self.darwinModules.base ];

  nixpkgs.hostPlatform = "x86_64-darwin";

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
