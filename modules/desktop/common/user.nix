{ self, ... }:
{
  flake.modules.homeManager."desktop.user" = {
    imports = [
      self.modules.homeManager.rime
      self.modules.homeManager.appearance
      self.modules.homeManager.shortcuts
      self.modules.homeManager."desktop.launcher.vicinae"
    ];
  };
}
