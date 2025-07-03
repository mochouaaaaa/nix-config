{ self, ... }:
{
  imports = self.importModule' ./.;

  programs = {
    firefox = {
      profiles = {
        "${self.myvars.username}" = {
          extensions = {
            force = true;
          };
        };
      };
    };
  };
}
