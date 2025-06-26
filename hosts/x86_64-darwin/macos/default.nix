{ self, ... }:
{

  imports = [ self.darwinModules.base ];

  nixpkgs.hostPlatform = "x86_64-darwin";
}
