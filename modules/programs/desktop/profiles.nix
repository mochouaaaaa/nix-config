{
  flake.modules.homeManager."desktop.programs" = { self, ... }: {
    imports = [
      self.modules.homeManager."desktop.programs.browsers"
      self.modules.homeManager."desktop.programs.audio"
      self.modules.homeManager."desktop.programs.security"
      self.modules.homeManager."desktop.programs.communication"
      self.modules.homeManager."desktop.programs.email"
      self.modules.homeManager."desktop.programs.media"
      self.modules.homeManager."desktop.programs.notes"
      self.modules.homeManager."desktop.programs.remote"
      self.modules.homeManager."desktop.programs.office"
    ];
  };
}
