{ self, ... }:
{
  # imports = self.mylib.scanPaths ./.;
  imports = [ ./window ];
}
